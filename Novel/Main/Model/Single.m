//
//  Single.m
//  日程计划
//
//  Created by John on 16/1/18.
//  Copyright © 2016年 John. All rights reserved.
//

#import "Single.h"

@implementation Single

+(instancetype)shareSingle
{
    static Single *shareSingle = nil;
    
    //dispatch_once_t是线程安全，onceToken默认为0
    static dispatch_once_t onceToken;
    
    //dispatch_once宏可以保证代码块中的指令只会被执行一次
    dispatch_once(&onceToken, ^{
        //永远只会被执行一次，shareSingle只会被实例化一次
        shareSingle = [[self alloc] init];
    });
    return shareSingle;
}

-(instancetype)init
{
    if (self = [super init])
    {
        self.gid = nil;
        self.title = nil;
        self.lastChapter = nil;
        self.updateTime = nil;
        self.isAtIntroVc = NO;
        self.isReadAtDirView = NO;
        self.isPush = NO;
        self.indexBook = 0;
        self.index = 0;
        self.contentOffsetUp = 0;
        self.contentoffsetDown = 0;
        self.books = nil;
    }
    return self;
}

@end
