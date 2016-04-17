//
//  TabBar.h
//  Note
//
//  Created by John on 15/12/30.
//  Copyright © 2015年 John. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabBar;

@protocol TabBarDelegate <NSObject>

@optional

-(void)tabBarDelegate:(TabBar *)tabBar didSelectButton:(NSInteger)from to:(NSInteger)to;

@end

@interface TabBar : UIView

@property(nonatomic,weak) id<TabBarDelegate> delegate;

/**
 *  用来添加一个内部的按钮
 *
 *  @param name    按钮的图片
 *  @param selName 按钮选中时的图片
 */
-(void)addTabButtonWithName:(NSString *)name andSelectImage:(NSString *)selName;
@end
