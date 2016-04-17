//
//  RankingBook.m
//  Novel
//
//  Created by John on 16/3/27.
//  Copyright © 2016年 John. All rights reserved.
//

#import "RankingBook.h"
#import "AFNetworkTool.h"

@implementation RankingBook

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.gid = dict[@"gid"];
        self.title = dict[@"title"];
        self.author = dict[@"author"];
        self.summary = dict[@"summary"];
        self.category = dict[@"category"];
        self.coverImage = dict[@"coverImage"];
        self.status = dict[@"status"];
        self.reason = dict[@"reason"];
    }
    return self;
}
+ (instancetype)rankingWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+(void)getURLString:(NSString *)URLString objectString:(NSString *)objectStr arrayString:(NSString *)arrayStr successWithSummary:(void (^)(NSArray *summaryList))successWithSummary error:(void (^)(NSError *error))error
{
    NSAssert(successWithSummary != nil, @"必行传完成回调");
    [[AFNetworkTool shareNetworkTool] GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
        // 创建模型数组
        NSMutableArray *summaryList = [NSMutableArray array];
        
        NSDictionary *result = [responseObject objectForKey:objectStr];
        
        NSArray *summary = [result objectForKey:arrayStr];//简介数组
        
        // 遍历数组
        [summary enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             
             // 字典转模型
             RankingBook *ranking = [RankingBook rankingWithDict:obj];
             // 将模型添加到数组中
             [summaryList addObject:ranking];
         }];
        
        // 完成回调
        successWithSummary (summaryList.copy);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
}
@end
