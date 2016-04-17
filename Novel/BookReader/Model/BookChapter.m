//
//  BookChapter.m
//  Novel
//
//  Created by John on 16/3/29.
//  Copyright © 2016年 John. All rights reserved.
//

#import "BookChapter.h"
#import "Contents.h"
#import "AFNetworkTool.h"

@implementation BookChapter

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.index = dict[@"index"];
        self.cid = dict[@"cid"];
        self.text = dict[@"text"];
        self.href = dict[@"href"];
        self.updateTime = dict[@"optimize_update_time"];
        
        self.coverImage = dict[@"coverImage"];
        self.title = dict[@"title"];
        self.gid = dict[@"gid"];
        
        //取出原来的字典数组
        NSArray *dictArray = dict[@"contentList"];
        
        //创建新的数组来存储
        NSMutableArray *contentList = [NSMutableArray array];
        
        for (NSDictionary *dict in dictArray)
        {
            //创建模型
            Contents *content = [Contents contentWithDict:dict];
            //添加
            [contentList addObject:content];
        }
        _contentList = contentList;//赋值
    }
    return self;
}

+(instancetype)bookChapterWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}


+(void)getURLString:(NSString *)URLString success:(void (^)(NSArray *groupList))success error:(void (^)(NSError *error))error
{
    NSAssert(success != nil, @"必行传完成回调");
    [[AFNetworkTool shareNetworkTool] GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
        // 创建模型数组
        NSMutableArray *groupList = [NSMutableArray array];
        
        NSDictionary *data = [responseObject objectForKey:@"data"];
        NSArray *group = [data objectForKey:@"group"];
        
        // 遍历数组
        [group enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             // 字典转模型
             BookChapter *book = [BookChapter bookChapterWithDict:obj];
             
             // 将模型添加到数组中
             [groupList addObject:book];
         }];
        // 完成回调
        success (groupList.copy);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
}


@end
