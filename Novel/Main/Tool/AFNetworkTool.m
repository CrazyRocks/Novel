//
//  AFNetworkTool.m
//  Novel
//
//  Created by John on 16/3/27.
//  Copyright © 2016年 John. All rights reserved.
//

#import "AFNetworkTool.h"

@implementation AFNetworkTool

/**
 *  返回一个单例对象
 */
+ (instancetype)shareNetworkTool
{
    static AFNetworkTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 创建会话配置对象
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration  ];
        // 设置请求时长
        config.timeoutIntervalForRequest = 5.0;
        instance = [[self alloc] initWithBaseURL:nil sessionConfiguration:config];
        // 设置响应解析数据的类型
        //        instance.responseSerializer = [[AFXMLParserResponseSerializer alloc] init];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        
        ((AFJSONResponseSerializer *)instance.responseSerializer).readingOptions = NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers;
        
    });
    return instance;
}

@end
