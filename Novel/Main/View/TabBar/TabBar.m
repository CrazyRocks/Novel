//
//  TabBar.m
//  Note
//
//  Created by John on 15/12/30.
//  Copyright © 2015年 John. All rights reserved.
//

#import "TabBar.h"
#import "TabBarButton.h"

@interface TabBar()
@property(nonatomic,weak) TabBarButton *buttonSelect;
@end


@implementation TabBar

-(void)addTabButtonWithName:(NSString *)name andSelectImage:(NSString *)selName
{
    TabBarButton *button = [TabBarButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:selName] forState:UIControlStateSelected];
    
    
    
    [self addSubview:button]; //添加到TabBar
    
    //监听
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    if (self.subviews.count == 1)
    {
        [self buttonClick:button];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i<self.subviews.count; i++)
    {
        TabBarButton *button = self.subviews[i]; // 从self里取出5个子控件
        
        //按钮的tag
        button.tag = i;
        
        //设置frame
        CGFloat buttonW = self.frame.size.width / self.subviews.count;
        CGFloat buttonH = self.frame.size.height;
        CGFloat buttonX = i * buttonW;
        CGFloat buttonY = 0;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }
}


/**
 *  监听按钮点击
 */
- (void)buttonClick:(TabBarButton *)button
{
    //通知代理
    if ([self.delegate respondsToSelector:@selector(tabBarDelegate:didSelectButton:to:)])
    {
        [self.delegate tabBarDelegate:self didSelectButton:self.buttonSelect.tag to:button.tag];
    }
    
    // 1.让当前选中的按钮取消选中
    self.buttonSelect.selected = NO;
    
    // 2.让新点击的按钮选中
    button.selected = YES;
    
    // 3.新点击的按钮就成为了"当前选中的按钮"  注意不要写成    self.buttonSelect.selected = button;
    self.buttonSelect = button;
    
    //4.切换子控制器
    //    self.selectedIndex = button.tag;
    
}
@end
