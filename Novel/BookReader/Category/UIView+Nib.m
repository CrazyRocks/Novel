//
//  UIView+Nib.m
//  Novel
//
//  Created by John on 16/3/22.
//  Copyright © 2016年 John. All rights reserved.
//

#import "UIView+Nib.h"

@implementation UIView (Nib)

+ (instancetype)createViewFromNibName:(NSString *)nibName
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    return [nib objectAtIndex:0];
}

+ (instancetype)createViewFromNib
{
    return [self createViewFromNibName:NSStringFromClass(self.class)];
}

@end
