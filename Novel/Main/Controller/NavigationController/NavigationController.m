//
//  NavigationController.m
//  Novel
//
//  Created by John on 16/3/22.
//  Copyright © 2016年 John. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //导航栏
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    attr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    // 设置标题样式
    [bar setTitleTextAttributes:attr];
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置导航栏上面的item 的 字体属性
    [item setTitleTextAttributes:attr forState:UIControlStateNormal];
    
    // 设置返回按钮的图片或者标题的颜色
    bar.tintColor = [UIColor whiteColor];
}

/**
 *  重写这个方法，能拦截所有的Push操作
 */
//-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    viewController.hidesBottomBarWhenPushed = YES;
//    [super pushViewController:viewController animated:animated];
//}

@end
