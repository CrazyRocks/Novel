//
//  Contents.m
//  Novel
//
//  Created by John on 16/3/30.
//  Copyright © 2016年 John. All rights reserved.
//

#import "Contents.h"
#import "AFNetworkTool.h"

@implementation Contents

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.chapter = dict[@"chapter"];
        self.detailURL = dict[@"detailURL"];
    }
    return self;
}
+ (instancetype)contentWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}




+(void)getURLString:(NSString *)URLString success:(void (^)(NSString *content))success error:(void (^)(NSError *error))error
{
    NSString *url = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSAssert(success != nil, @"必行传完成回调");
    [[AFNetworkTool shareNetworkTool] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
        NSDictionary *data = [responseObject objectForKey:@"data"];
        NSDictionary *content = [data objectForKey:@"content"];
        
        NSString *contentString = (NSString *)content;
        
        contentString= [contentString stringByReplacingOccurrencesOfString:@"<p style=\"text-indent:2em;\">" withString:@"  "];
        contentString= [contentString stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n  "];
        
        // 完成回调
        success (contentString.copy);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
}


/*
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;//换行
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@"\n  "];
    }
    return html;
}
 */

@end
