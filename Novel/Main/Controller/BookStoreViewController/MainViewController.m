//
//  MainViewController.m
//  BabyKnow
//
//  Created by user on 16/3/23.
//  Copyright © 2016年 BoCo. All rights reserved.
//

#import "MainViewController.h"
#import "RankingViewController.h"
#import "TopViewController.h"
#import "RecommendViewController.h"
#import "ClassViewController.h"
#import "Public.h"


static CGFloat const titleH = 44;
static CGFloat const maxTitleScale = 1.3;

//#define ScreenW [UIScreen mainScreen].bounds.size.width
//#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface MainViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *titleScrollView;
@property (nonatomic, weak) UIScrollView *contentScrollView;
// 选中按钮
@property (nonatomic, weak) UIButton *selTitleButton;

@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation MainViewController

- (NSMutableArray *)buttons
{
    if (!_buttons)
    {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;  //导航栏的背景色是黑色
    
    [self setupTitleScrollView];
    [self setupContentScrollView];
    [self addChildViewController];
    [self setupTitle];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * ScreenW, 0);
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - 设置头部标题栏
- (void)setupTitleScrollView
{
    // 判断是否存在导航控制器来判断y值
//    CGFloat y = self.navigationController ? navBarH : 0;
    CGRect rect = CGRectMake(0, 0, ScreenW, titleH);
    
    UIScrollView *titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    titleScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleScrollView];
    
    self.titleScrollView = titleScrollView;
}

#pragma mark - 设置内容
- (void)setupContentScrollView
{
    CGFloat y = CGRectGetMaxY(self.titleScrollView.frame);
    CGRect rect = CGRectMake(0, y, ScreenW, ScreenH - navBarH);
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:rect];
    //    contentScrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:contentScrollView];
    
    self.contentScrollView = contentScrollView;
}

#pragma mark - 添加子控制器
- (void)addChildViewController
{
    RankingViewController *vc = [[RankingViewController alloc] init];
    vc.title = @"排行";
    [self addChildViewController:vc];
    
    RecommendViewController *vc1 = [[RecommendViewController alloc] init];
    vc1.title = @"推荐";
    [self addChildViewController:vc1];
    
    TopViewController *vc2 = [[TopViewController alloc] init];
    vc2.title = @"榜单";
    [self addChildViewController:vc2];
    
    ClassViewController *vc3 = [[ClassViewController alloc] init];
    vc3.title = @"分类";
    [self addChildViewController:vc3];
}

#pragma mark - 设置标题
- (void)setupTitle
{
    NSUInteger count = self.childViewControllers.count;
    
    CGFloat x = 0;
    CGFloat w = ScreenW / count;
    CGFloat h = titleH;
    
    for (int i = 0; i < count; i++)
    {
        UIViewController *vc = self.childViewControllers[i];
        
        x = i * w;
        CGRect rect = CGRectMake(x, 0, w, h);
        UIButton *btn = [[UIButton alloc] initWithFrame:rect];
        
        btn.tag = i;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [btn addTarget:self action:@selector(chick:) forControlEvents:UIControlEventTouchDown];
        
        [self.buttons addObject:btn];
        [self.titleScrollView addSubview:btn];
        
        if (i == 0)
        {
            [self chick:btn];
        }
        
    }
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
}

// 按钮点击
- (void)chick:(UIButton *)btn
{
    [self selTitleBtn:btn];
    
    NSUInteger i = btn.tag;
    CGFloat x = i * ScreenW;
    
    [self setUpOneChildViewController:i];
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
    
}
// 选中按钮
- (void)selTitleBtn:(UIButton *)btn
{
    [self.selTitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selTitleButton.transform = CGAffineTransformIdentity;
    
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.transform = CGAffineTransformMakeScale(maxTitleScale, maxTitleScale);
    
    self.selTitleButton = btn;
    [self setupTitleCenter:btn];
}

- (void)setUpOneChildViewController:(NSUInteger)i
{
    CGFloat x = i * ScreenW;
    
    UIViewController *vc = self.childViewControllers[i];
    
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(x, 0, ScreenW, ScreenH - self.contentScrollView.frame.origin.y);
    
    [self.contentScrollView addSubview:vc.view];
    
}

- (void)setupTitleCenter:(UIButton *)btn
{
    CGFloat offset = btn.center.x - ScreenW * 0.5;
    
    if (offset < 0)
    {
        offset = 0;
    }
    
    CGFloat maxOffset = self.titleScrollView.contentSize.width - ScreenW;
    if (offset > maxOffset)
    {
        offset = maxOffset;
    }
    
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger i = self.contentScrollView.contentOffset.x / ScreenW;
    [self selTitleBtn:self.buttons[i]];
    [self setUpOneChildViewController:i];
}

// 只要滚动UIScrollView就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger leftIndex = offsetX / ScreenW;
    NSInteger rightIndex = leftIndex + 1;
    
    //    NSLog(@"%zd,%zd",leftIndex,rightIndex);
    
    UIButton *leftButton = self.buttons[leftIndex];
    
    UIButton *rightButton = nil;
    if (rightIndex < self.buttons.count)
    {
        rightButton = self.buttons[rightIndex];
    }
    
    CGFloat scaleR = offsetX / ScreenW - leftIndex;
    
    CGFloat scaleL = 1 - scaleR;
    
    
    CGFloat transScale = maxTitleScale - 1;
    leftButton.transform = CGAffineTransformMakeScale(scaleL * transScale + 1, scaleL * transScale + 1);
    
    rightButton.transform = CGAffineTransformMakeScale(scaleR * transScale + 1, scaleR * transScale + 1);
    
    
    UIColor *rightColor = [UIColor colorWithRed:scaleR green:0 blue:0 alpha:1];
    UIColor *leftColor = [UIColor colorWithRed:scaleL green:0 blue:0 alpha:1];
    
    [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
    [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
    
    
}


@end
