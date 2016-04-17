//
//  AFNetworkTool.h
//  Novel
//
//  Created by John on 16/3/27.
//  Copyright © 2016年 John. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"

@interface AFNetworkTool : AFHTTPSessionManager

+ (instancetype)shareNetworkTool;

@end
