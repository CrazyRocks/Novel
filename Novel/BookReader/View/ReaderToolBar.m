//
//  ReaderToolBar.m
//  Novel
//
//  Created by John on 16/3/22.
//  Copyright © 2016年 John. All rights reserved.
//
#define btnCount 4
#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#import "ReaderToolBar.h"
#import "Public.h"

@interface ReaderToolBar()

@end

@implementation ReaderToolBar



-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupButton];
    }
    return self;
}
-(void)setupButton
{
    self.backgroundColor = Color(50, 50, 50);
    NSArray *titleArray = @[@"目录",@"缓存",@"设置",@"夜晚"];
    for (int i =0 ; i < btnCount; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSString *name = [NSString stringWithFormat:@"setting%d",i+1];
        
        [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        
        
        CGFloat imageEdgeInsetsTop = 0;
        
        CGFloat imageEdgeInsetsLeft = (button.frame.size.width - button.imageView.frame.size.width)*0.5;
        
        CGFloat imageEdgeInsetsBottom = 5;
        
        CGFloat imageEdgeInsetsRight = imageEdgeInsetsLeft;
        
        button.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
        
        //按钮的tag
        button.tag = i;
        
        //监听
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        
        //设置frame
        CGFloat buttonW = ScreenW / 4;
        CGFloat buttonH = CGRectGetHeight(self.frame);
        CGFloat buttonX = i * buttonW;
        CGFloat buttonY = 0;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        CGFloat labelW = buttonW;
        CGFloat labelH = buttonH * 0.2;
        CGFloat labelX = buttonX;
        CGFloat labelY = CGRectGetHeight(self.frame) - labelH -3;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = titleArray[i];
        
        [self addSubview:label];
        [self addSubview:button];;
        
    }
}


/**
 *  监听按钮点击
 */
- (void)buttonClick:(UIButton *)button
{
    //通知代理
    if ([self.delegate respondsToSelector:@selector(readerToolBarDelegate:didSelectButton:)])
    {
        [self.delegate readerToolBarDelegate:self didSelectButton:button.tag];
    }
}






@end
