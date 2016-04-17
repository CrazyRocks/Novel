//
//  Contents.h
//  Novel
//
//  Created by John on 16/3/30.
//  Copyright © 2016年 John. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Contents : NSObject

/**
 *  内容
 */
@property(nonatomic,copy) NSString *chapter;
/**
 *  URL
 */
@property(nonatomic,copy) NSString *detailURL;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)contentWithDict:(NSDictionary *)dict;

+(void)getURLString:(NSString *)URLString success:(void (^)(NSString *content))success error:(void (^)(NSError *error))error;

@end
