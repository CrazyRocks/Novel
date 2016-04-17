//
//  UIView+Nib.h
//  Novel
//
//  Created by John on 16/3/22.
//  Copyright © 2016年 John. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Nib)

/**
 *  根据xib的class创建
 */
+ (instancetype)createViewFromNib;
/**
 *  根据xib的名字创建
 */
+ (instancetype)createViewFromNibName:(NSString *)nibName;

@end
