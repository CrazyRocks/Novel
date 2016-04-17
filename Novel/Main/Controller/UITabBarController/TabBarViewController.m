//
//  TabBarViewController.m
//  Novel
//
//  Created by John on 16/3/23.
//  Copyright © 2016年 John. All rights reserved.
//

#import "TabBarViewController.h"
#import "TabBar.h"

@interface TabBarViewController ()<TabBarDelegate>

@property(nonatomic,weak) UIButton *buttonSelect;

@end

@implementation TabBarViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.添加自己的tabbar
    TabBar *myTabBar = [[TabBar alloc] init];
    myTabBar.delegate = self;
    myTabBar.frame = self.tabBar.bounds;
    [self.tabBar addSubview:myTabBar];
    
    
    // 添加对应个数的按钮
    for (int i = 0; i< self.viewControllers.count; i++)
    {
        NSString *name = [NSString stringWithFormat:@"TabBar%d",i+1];
        NSString *selName = [NSString stringWithFormat:@"TabBar%dSel",i+1];
        [myTabBar addTabButtonWithName:name andSelectImage:selName];
    }
    
    self.tabBar.tintColor = [UIColor redColor]; //设置选中颜色
}
-(void)tabBarDelegate:(TabBar *)tabBar didSelectButton:(NSInteger)from to:(NSInteger)to
{
    self.selectedIndex = to; //选中最新的
}

@end
