//
//  ReadingViewController.m
//  Novel
//
//  Created by John on 16/4/2.
//  Copyright © 2016年 John. All rights reserved.
//
#define bookShelf [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"bookShelf.plist"]

#define myStatusBar @"myStatusBar"

#import "ReadingViewController.h"
#import "Public.h"
#import "BookChapter.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ReadCell.h"
#import "IntroViewController.h"
#import "Single.h"
#import "BookChapter.h"
#import "ReaderTop.h"
#import "Contents.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "ReaderSettingBar.h"
#import "ReaderToolBar.h"
#import "UIView+Nib.h"
#import "Contents.h"
#import "DiretoryView.h"

@interface ReadingViewController ()<ReaderTopDelegate,ReaderToolBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    // 不使用 @synthesize 只在这里写表示这个属性是私有属性
    // 不断给它赋值时不会改变引用计数
    CGFloat contentOffsetY;
}
@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *group;

@property(nonatomic,strong) NSMutableArray *totolList; //总章节

@property(nonatomic,assign) BOOL isShowNavigationBar; //
@property(nonatomic,assign) BOOL isShowStatusBar; //控制statusBar的显示与隐藏

@property (nonatomic, weak) ReaderToolBar *toolBar;

@property(nonatomic,weak) ReaderTop *topBar;

@property (nonatomic, weak) ReaderSettingBar *settingBar;

@property(nonatomic,weak) UIView *statusBarView;

@property(nonatomic,weak) UIView *coverView;

@property(nonatomic,strong) Single *single;

@property(nonatomic,copy) NSString *filePath;

@property(nonatomic,assign) NSInteger preIndex;

@property(nonatomic,assign) NSInteger nextIndex;

@property(nonatomic,assign) BOOL isIndex;

@property(nonatomic,strong) NSIndexPath *indexPath;

@property(nonatomic,weak) DiretoryView *diretoryView;

@end

@implementation ReadingViewController


- (Single *)single
{
    if (!_single)
    {
        _single = [Single shareSingle];
    }
    return _single;
}

- (NSMutableArray *)totolList
{
    if (!_totolList)
    {
        // 初始化
        //1.路径
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",self.single.title]];
       
        // 2.加载数组
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:filePath];
        
        // 3.将dictArray里面的所有字典转成模型对象,放到新的数组中
        NSMutableArray *totalArray = [NSMutableArray array];
        
        for (NSDictionary *dict in dictArray)
        {
            // 3.1.创建模型对象
            BookChapter *bookChapter = [BookChapter bookChapterWithDict:dict];
            
            // 3.2.添加模型对象到数组中
            [totalArray addObject:bookChapter];
        }
        _totolList = totalArray;
    }
    return _totolList;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = Color(161, 160, 136);// 黄色
    
    self.view.backgroundColor = Color(161, 160, 136);// 黄色
    
    [self statusAndNavigation];//状态栏和导航栏的设置
    
    [self settingTableView];
    
    self.single.contentOffsetUp = 0;
    self.single.contentoffsetDown = 0;
}

//tableView

- (void)settingTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-5) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    _tableView.backgroundColor  =Color(161, 160, 136);// 黄色
    
    [self.view addSubview:_tableView];
    
    UINib *cellNib = [UINib nibWithNibName:@"ReadCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"FDFeedCell"];
    
    
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(preChapter)];
    
    //开始刷新
    [self jumpDir:_index];//第n章
    
    //加载更多
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextChapter)];
}

//状态栏和导航栏

- (void)statusAndNavigation
{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;  //导航栏的背景色是黑色
    self.isShowNavigationBar = YES;
    self.isShowStatusBar = YES;//刚打开隐藏
}
- (BOOL)prefersStatusBarHidden
{
    return self.isShowStatusBar;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self.navigationController setNavigationBarHidden:_isShowNavigationBar animated:YES];  //BOOL默认NO
}
#pragma mark - add view

- (void)hideReaderSettingBar
{
    [UIView animateWithDuration:0 animations:^{
        
        self.isShowStatusBar = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        
        _tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-5);
        
        _topBar.frame = CGRectMake(0, 20, ScreenW, 44);
        
        _topBar.frame = CGRectMake(0, -CGRectGetHeight(_topBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(_topBar.frame));
        _toolBar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(_toolBar.frame));
        
    } completion:^(BOOL finished) {
        [_toolBar removeFromSuperview];
        [_topBar removeFromSuperview];
        _topBar = nil;
        [_toolBar removeFromSuperview];
        _toolBar = nil;
        [_statusBarView removeFromSuperview];
        _statusBarView = nil;
        [_coverView removeFromSuperview];
        _coverView = nil;
        
    }];
}
// 显示设置
- (void)showReaderSettingBar:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *coverView = [[UIView alloc] initWithFrame:window.bounds];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideReaderSettingBar)];
    
    [coverView addGestureRecognizer:tap];
    
    _coverView = coverView;
    
    [window addSubview:coverView];
    
    
    //添加状态栏
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 20)];
    
    statusBarView.backgroundColor= Color(50, 50, 50);
    
    _statusBarView = statusBarView;
    
    [coverView addSubview:statusBarView];
    
    ReaderTop *topBar = [ReaderTop createViewFromNib];
    
    topBar.frame = CGRectMake(0, 0, CGRectGetWidth(topBar.frame), 0);
    
    topBar.delegate = self;
    
    topBar.label.text = self.single.title;
    
    _topBar =topBar;
    
    [coverView addSubview:topBar];
    
    ReaderToolBar *toolBar = [[ReaderToolBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(coverView.frame), ScreenW, 44)];
    toolBar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(toolBar.frame));
    
    toolBar.delegate = self;
    
    [coverView addSubview:toolBar];
    _toolBar = toolBar;
    
    
    [UIView animateWithDuration:0.2 animations:^{
        self.isShowStatusBar = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        
        _tableView.frame = CGRectMake(0, -20, ScreenW, ScreenH-5);
        
        _topBar.frame = CGRectMake(0, 20, ScreenW, 44);
        
        _toolBar.frame = CGRectMake(0, CGRectGetHeight(coverView.frame) - CGRectGetHeight(_toolBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(_toolBar.frame));
    }];
}
/**
 *  加载
 *  与&&
 *  或||
 *  非!
 */
- (void)preChapter
{
    if (_isIndex == NO)
    {
        //没有上一章
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:_index];
        
        BookChapter *group = self.totolList[indexPath.section];
        Contents *chapters = group.contentList[indexPath.row];
        
        [Contents getURLString:chapters.detailURL success:^(NSString *content) {
            
            chapters.chapter = content;
            NSMutableArray *dictArray = [NSMutableArray arrayWithObject:group];
            
            if (self.group.count == 0)
            {
                self.group = dictArray;
            }
            else
            {
                [self.group insertObject:group atIndex:0];
            }
            
            
            [self.tableView reloadData];
            
            //停止刷新
            [self.tableView.mj_header endRefreshing];
            
            self.tableView.mj_header.hidden = YES;
            
        } error:^(NSError *error) {
            
        }];
    }
    else
    {
        if (_preIndex == 0)
        {
            [self.tableView.mj_header endRefreshing];
            self.tableView.mj_header.hidden = YES;
            return;
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:_preIndex-1];
        
        BookChapter *group = self.totolList[indexPath.section];
        Contents *chapters = group.contentList[indexPath.row];
        
        
        [Contents getURLString:chapters.detailURL success:^(NSString *content) {
            
            chapters.chapter = content;
            NSMutableArray *dictArray = [NSMutableArray arrayWithObject:group];
            
            if (self.group.count == 0)
            {
                self.group = dictArray;
            }
            else
            {
                [self.group insertObject:group atIndex:0];
            }
            
            
            [self.tableView reloadData];
            
            //停止刷新
            [self.tableView.mj_header endRefreshing];
            
            _preIndex --;
            if (_preIndex == 0)
            {
                self.tableView.mj_header.hidden = YES;
            }
            
        } error:^(NSError *error) {
            
        }];
        
    }
    
}

/**
 *  加载下一章
 */
- (void)nextChapter
{
    if (_index >= self.totolList.count - 1 || _nextIndex >= self.totolList.count -1)
    {
        self.tableView.mj_footer.hidden = YES;
        return;
    }
    
    if (_isIndex == NO)
    {
        
        _index++;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:_index];
        
        BookChapter *group = self.totolList[indexPath.section];
        Contents *chapters = group.contentList[indexPath.row];
        
        [Contents getURLString:chapters.detailURL success:^(NSString *content) {
            
            chapters.chapter = content;
            [self.group addObject:group];
            
            
            self.tableView.mj_footer.hidden = NO;
            
            [self.tableView.mj_footer endRefreshing]; //停止刷新
            //刷新
            [self.tableView reloadData];
            
        } error:^(NSError *error) {
            
        }];
    }
    else
    {
        _nextIndex++;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:_nextIndex];
        
        BookChapter *group = self.totolList[indexPath.section];
        Contents *chapters = group.contentList[indexPath.row];
        
        [Contents getURLString:chapters.detailURL success:^(NSString *content) {
            
            chapters.chapter = content;
            [self.group addObject:group];
            
            
            self.tableView.mj_footer.hidden = NO;
            
            [self.tableView.mj_footer endRefreshing]; //停止刷新
            //刷新
            [self.tableView reloadData];
            
        } error:^(NSError *error) {
            
        }];
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.group.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BookChapter *group = self.group[section];
    return group.contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FDFeedCell"];
    BookChapter *group = self.group[indexPath.section];
    Contents *content = group.contentList[indexPath.row];
    
    cell.content = content;
    cell.bookChapter = group;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//去除选中的样式
    
    cell.backgroundColor = Color(161, 160, 136);// 黄色
    
    return cell;
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"FDFeedCell" cacheByIndexPath:indexPath configuration:^(ReadCell *cell) {
        BookChapter *group = self.group[indexPath.section];
        Contents *content = group.contentList[indexPath.row];
        
        cell.content = content;
    }];
}
#pragma mark - 组标题-章节名
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 20)];
    
    headerView.backgroundColor = Color(161, 160, 136);// 黄色
    
    BookChapter *group = self.group[section];
    
    UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
    label.text = group.text;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14.f];
    
    [headerView addSubview:label];
    
    return headerView;
}
//heightForHeaderInSection高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}


#pragma mark - tableViewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showReaderSettingBar:indexPath];
}
/**
 *  tableview停止滚动时打印出contentOffset
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:self.single.title]) return;
    //判断是否加入了书架 --只有加入书架的才会保存进度
    if ([[NSUserDefaults standardUserDefaults] boolForKey:self.single.title])
    {
        if (scrollView.dragging)
        { // 拖拽
            if ((scrollView.contentOffset.y - contentOffsetY) > 5.0f)
            {
                // 向上拖拽 -->向下滑动
                NSArray *cells = [self.tableView visibleCells];
                
                if (cells.count == 1)
                {
                    if (scrollView.contentOffset.y > 0)
                    {
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        
                        if (self.single.contentoffsetDown > 0)
                        {
                            [defaults setInteger:scrollView.contentOffset.y - self.single.contentoffsetDown forKey:[NSString stringWithFormat:@"%@%@",self.single.title,token]];
                        }
                        else
                        {
                            [defaults setInteger:scrollView.contentOffset.y forKey:[NSString stringWithFormat:@"%@%@",self.single.title,token]];
                        }
                        
                        [defaults removeObjectForKey:@"first"];
                        [defaults synchronize];//同步
                    }
                }
                
                else if (cells.count == 2)
                {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    NSMutableArray *dictAarray = [NSMutableArray arrayWithContentsOfFile:bookShelf];
                    
                    [defaults setInteger:0.0f forKey:[NSString stringWithFormat:@"%@%@",self.single.title,token]];
                    
                    if (![defaults boolForKey:@"first"])
                    {
                        [defaults setBool:YES forKey:@"first"];
                        
                        UITableViewCell *cell = [cells firstObject];
                        
                        self.single.contentoffsetDown = CGRectGetMaxY(cell.frame);
                        
                    }
                    
                    NSMutableDictionary *item = [dictAarray objectAtIndex:self.single.indexBook];
                    
                    [item setValue:[NSString stringWithFormat:@"%ld",self.single.index] forKey:@"index"];
                    
                    [dictAarray writeToFile:bookShelf atomically:YES];
                    
                }
                
                
            }
            //
            else if ((contentOffsetY - scrollView.contentOffset.y) > 5.0f)
            {
                // 向下拖拽 --向上滑动
                //暂时不做啦
                //
            }
            
        }
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //开始拖拽
    contentOffsetY = scrollView.contentOffset.y;
}

// 完成拖拽(滚动停止时调用此方法，手指离开屏幕前)
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    // NSLog(@"scrollViewDidEndDragging");
//    oldContentOffsetY = scrollView.contentOffset.y;
//    NSLog(@"停止拖拽");
//}


//目录选择
- (void)jumpDir:(NSInteger)index
{
    [_tableView.mj_header endRefreshing];//停止刷新
    if (index > 0)
    {
        self.tableView.mj_header.hidden = NO;
    }
    
    [self.group removeAllObjects]; //清空前面的数据
    
    _preIndex = _nextIndex = index;//赋值
    _isIndex = YES;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    
    BookChapter *group = self.totolList[indexPath.section];
    Contents *chapters = group.contentList[indexPath.row];
    
    [Contents getURLString:chapters.detailURL success:^(NSString *content) {
        
        chapters.chapter = content;
        NSMutableArray *dictArray = [NSMutableArray arrayWithObject:group];
        self.group = dictArray;
        
        [self.tableView reloadData];
        
        NSInteger y = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%@%@",self.single.title,token]];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:self.single.title])
        {
            if (self.single.isReadAtDirView == NO)
            {
                //已经加入书架的，那么按保存的进度读取
                if (![[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%@%@",self.single.title,token]])
                {
                    [self.tableView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
                }
                else
                {
                    [self.tableView setContentOffset:CGPointMake(0.0f, y) animated:NO];
                }
            }
            else
            {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];//跳转到最开始
                //存储下偏移量，因为这时候tableview不滚动是不会调用scrollViewDidScroll方法的
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setInteger:0.0f forKey:[NSString stringWithFormat:@"%@%@",self.single.title,token]];
            }
        }
        else
        {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];//跳转到最开始
        }
        
    } error:^(NSError *error) {
        
    }];
}


#pragma ReaderTopDelegate
- (void)backBVc
{
    [self hideReaderSettingBar];
    
    [self.totolList removeAllObjects];
    self.totolList = nil;
    [self.group removeAllObjects];
    self.group = nil;
    self.single.isReadAtDirView = NO;
    
    if ([self.delegate respondsToSelector:@selector(reloadData:)])
    {
        [self.delegate reloadData:self];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma ReaderToolBarDelegate
- (void)dirtory
{
    self.single.isAtIntroVc = NO;
    self.single.isReadAtDirView = NO;
    [self hideReaderSettingBar];
    
    self.tableView.scrollEnabled = NO; //tableView不能滑动
    
    self.isShowStatusBar = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    
    DiretoryView *diretoryView = [[DiretoryView alloc] initWithDirtoryView];
    
    diretoryView.frame = CGRectMake(0, ScreenH, ScreenW, 0);
    
    [self.view addSubview:diretoryView];
    
    _diretoryView = diretoryView;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        _diretoryView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeView)];
}

- (void)closeView
{
    [_tableView reloadData];
    self.isShowStatusBar = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"dirtory" object:nil];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        _diretoryView.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH-64);
        
        
    } completion:^(BOOL finished) {
        
        [_diretoryView removeFromSuperview];
        _diretoryView = nil;
        self.tableView.scrollEnabled = YES;
    }];
    
}
- (void)reloadTableView:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    NSInteger index = [[dict objectForKey:@"indexPath"] integerValue];
    
    [self jumpDir:index];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //删除通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dirtory" object:nil];
    });
}

- (void)downLoad
{
    [MBProgressHUD showMessage:@"正在开发中"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUD];
        
    });
}

- (void)setting
{
    [MBProgressHUD showMessage:@"正在开发中"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUD];
        
    });
}

- (void)dayOrNight
{
    [MBProgressHUD showMessage:@"正在开发中"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUD];
        
    });
}
- (void)readerToolBarDelegate:(ReaderToolBar *)toolBar didSelectButton:(NSInteger)tag
{
    if (tag == 0)
    {
        //目录
        [self dirtory];
    }
    else if (tag == 1)
    {
        //缓存
        [self downLoad];
    }
    else if (tag == 2)
    {
        //设置
        [self setting];
    }
    else
    {
        //状态白天或者夜晚
        [self dayOrNight];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

