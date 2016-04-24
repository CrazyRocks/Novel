//
//  BookChapter.h
//  Novel
//
//  Created by John on 16/3/29.
//  Copyright © 2016年 John. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookChapter : NSObject


@property(nonatomic,copy) NSNumber *index;  //这里不获取Json里的index,有时候返回的Index不对，直接for循环++
@property(nonatomic,copy) NSString *cid;
@property(nonatomic,copy) NSString *text; //章节名称
@property(nonatomic,copy) NSString *href;
@property(nonatomic,copy) NSString *updateTime; //更新时间

@property(nonatomic,copy) NSString *coverImage;
@property(nonatomic,copy) NSString *gid;
@property(nonatomic,copy) NSString *title;


/**
 *  存放当前章节内容、url
 */
@property(nonatomic,strong) NSMutableArray *contentList;

- (instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)bookChapterWithDict:(NSDictionary *)dict;


+(void)getURLString:(NSString *)URLString success:(void (^)(NSArray *groupList))success error:(void (^)(NSError *error))error;

@end
