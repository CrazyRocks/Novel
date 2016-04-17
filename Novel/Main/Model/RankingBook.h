//
//  RankingBook.h
//  Novel
//
//  Created by John on 16/3/27.
//  Copyright © 2016年 John. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankingBook : NSObject


@property (nonatomic, copy) NSString *gid;     // 书本id
@property (nonatomic, copy) NSString *title;   // 书本名
@property(nonatomic,copy) NSString *author;    //作者
@property (nonatomic, copy) NSString *summary;   // 简介
@property (nonatomic, copy) NSString *category;   // 类别
@property(nonatomic,copy) NSString *coverImage;//封面图片地址
@property(nonatomic,copy) NSString *status;//完结或连载
@property(nonatomic,copy) NSString *reason;


/**
 *  排行的URL字符串
 */
//@property (nonatomic, copy) NSString *rankingURLStirng;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)rankingWithDict:(NSDictionary *)dict;

/**
 *  加载排行数据
 *  @param succeses  完成回调
 *  @param error     失败回调
 */
+(void)getURLString:(NSString *)URLString objectString:(NSString *)objectStr arrayString:(NSString *)arrayStr successWithSummary:(void (^)(NSArray *summaryList))successWithSummary error:(void (^)(NSError *error))error;

@end
