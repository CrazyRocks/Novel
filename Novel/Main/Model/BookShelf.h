//
//  BookShelf.h
//  Novel
//
//  Created by John on 16/4/13.
//  Copyright © 2016年 John. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookShelf : NSObject

@property (nonatomic, copy) NSString *gid;     // 书本id
@property (nonatomic, copy) NSString *title;   // 书本名
@property(nonatomic,copy) NSString *coverImage;//封面图片地址
@property(nonatomic,copy) NSString *lastChapter;
@property(nonatomic,copy) NSString *updateTIme;
@property(nonatomic,copy) NSString *index; //读到的位置


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)bookShelfWithDict:(NSDictionary *)dict;

@end
