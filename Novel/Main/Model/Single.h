//
//  Single.h
//  日程计划
//
//  Created by John on 16/1/18.
//  Copyright © 2016年 John. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Single : NSObject

@property(nonatomic,copy) NSString *gid;
@property(nonatomic,copy) NSString *title;//名称

@property(nonatomic,copy) NSString *lastChapter;//最后一张
@property(nonatomic,copy) NSString *updateTime;//更新时间

@property(nonatomic,strong) NSMutableArray *books;

@property(nonatomic,assign) NSInteger index;
@property(nonatomic,assign) NSInteger indexBook; //哪个本的在plist中的位置
@property(nonatomic,assign) CGFloat contentOffsetUp;
@property(nonatomic,assign) CGFloat contentoffsetDown;

@property(nonatomic,assign) BOOL isAtIntroVc;
@property(nonatomic,assign) BOOL isReadAtDirView;
@property(nonatomic,assign) BOOL isPush;

+(instancetype)shareSingle;

@end
