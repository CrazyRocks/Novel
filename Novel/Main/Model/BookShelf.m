//
//  BookShelf.m
//  Novel
//
//  Created by John on 16/4/13.
//  Copyright © 2016年 John. All rights reserved.
//

#import "BookShelf.h"

@implementation BookShelf

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.title = dict[@"title"];
        self.gid = dict[@"gid"];
        self.coverImage = dict[@"coverImage"];
        self.lastChapter = dict[@"lastChapter"];
        self.updateTIme = dict[@"optimize_update_time"];
        self.index = dict[@"index"];
    }
    return self;
}
+ (instancetype)bookShelfWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
