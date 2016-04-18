//
//  IntroViewController.m
//  Novel
//
//  Created by John on 16/3/28.
//  Copyright © 2016年 John. All rights reserved.
//

#import "IntroViewController.h"
#import "Public.h"
#import "RankingBook.h"
#import "IntroCell.h"
#import "ReadingViewController.h"
#import "Single.h"
#import "BookChapter.h"
#import "DiretoryView.h"
#import "MBProgressHUD+MJ.h"

@interface IntroViewController ()<IntroCellDelegate>

@property(nonatomic,strong) NSMutableArray *totalList;

@property(nonatomic,weak) DiretoryView *diretoryView;

@property(nonatomic,copy) NSString *filePath;

@property(nonatomic,strong) Single *single;

@end

@implementation IntroViewController


- (Single *)single
{
    if (!_single)
    {
        _single = [Single shareSingle];
    }
    return _single;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 64, ScreenW, ScreenH);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backVc)];
    
    self.single.gid = self.rankingBook.gid;
    self.single.title = self.rankingBook.title;
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    
    [self.view addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backVc)]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.single.isAtIntroVc = YES;
    
    [self setupData];
}

- (void)backVc
{
    //判断沙盒中是否存在改文件
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    if ([mgr fileExistsAtPath:_filePath]) //存在
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:self.rankingBook.title]) //已加入书单
        {
            
        }
        else
        {
            //没有加入书单
            [mgr removeItemAtPath:_filePath error:nil];//删除
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupData
{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",self.rankingBook.title]]; //沙盒
    
    _filePath = filePath;
    
    //判断沙盒中是否存在改文件
    NSFileManager *mgr = [NSFileManager defaultManager];
    if (![mgr fileExistsAtPath:filePath])
    {
        [MBProgressHUD showMessage:@""];
        NSString *url = [NSString stringWithFormat:@"http://m.baidu.com/tc?ajax=1&appui=alaxs&dir=1&gid=%@",self.rankingBook.gid];//全部章节
        
        [BookChapter getURLString:url success:^(NSArray *groupList) {
            
            self.totalList = [NSMutableArray arrayWithArray:groupList];
            
            NSMutableArray *bookList = [NSMutableArray new]; //组
            
            for (int i = 0; i < groupList.count; i++)
            {
                BookChapter *bookChapter = self.totalList[i];
                
                NSMutableDictionary *item = [NSMutableDictionary new];
                
                [item setObject:bookChapter.index forKey:@"index"];
                [item setObject:bookChapter.cid forKey:@"cid"];
                [item setObject:bookChapter.text forKey:@"text"];
                [item setObject:bookChapter.href forKey:@"href"];
                [item setObject:self.rankingBook.gid forKey:@"gid"];
                [item setObject:self.rankingBook.coverImage forKey:@"coverImage"];
                [item setObject:self.rankingBook.title forKey:@"title"];
                [item setObject:bookChapter.updateTime forKey:@"optimize_update_time"];
                
                NSString *chapterUrl = [NSString stringWithFormat:@"http://m.baidu.com/tc?ajax=1&appui=alaxs&cid=%@&gid=%@&src=%@",bookChapter.cid,self.rankingBook.gid,bookChapter.href];//某一章节
                
                NSMutableArray *contentList = [NSMutableArray array];
                
                NSMutableDictionary *contentItem = [NSMutableDictionary dictionary];
                
                [contentItem setObject:chapterUrl forKey:@"detailURL"];
                [contentItem setObject:@"" forKey:@"chapter"];
                
                [contentList addObject:contentItem];
                
                [item setObject:contentList forKey:@"contentList"];
                
                [bookList addObject:item];
                
            }
            NSMutableDictionary *dict = [bookList lastObject];
            NSString *text = dict[@"text"];
            NSString *updateTime = dict[@"optimize_update_time"];
            
            self.single.lastChapter = text;
            self.single.updateTime = updateTime;
            
            [bookList writeToFile:filePath atomically:YES]; //写入不要放入for循环里面，否则内存崩溃
            [MBProgressHUD hideHUD];
            
            if (groupList.count == 0)
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.rankingBook.title message:@"暂时下架中，请稍后再来哦!😄" preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //点击按钮响应的事件
                    [self backVc];
                }]];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        } error:^(NSError *error) {
            
        }];
            
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IntroCell *cell = [IntroCell cellWithTableView:tableView];
    
    cell.delegate = self;
    
    cell.rankingBook = self.rankingBook;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//去除选中背景颜色
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400;
}
/**
 *  查看目录
 */
- (void)lookCategory
{
    DiretoryView *diretoryView = [[DiretoryView alloc] initWithDirtoryView];
    
    diretoryView.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH-64);
    
    _diretoryView = diretoryView;
    
    [self.view addSubview:diretoryView];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        diretoryView.frame = CGRectMake(0, 0, ScreenW, ScreenH-64);
        
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeView)];
    
}

//开始阅读
- (void)startReading
{
    ReadingViewController *read = [ReadingViewController new];
    
    //判断是否加入了书架
    if ([[NSUserDefaults standardUserDefaults] boolForKey:self.rankingBook.title])
    {
        //已经加入
        read.index = self.single.index - 1;
    }
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:read];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)closeView
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backVc)];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _diretoryView.frame = CGRectMake(0, ScreenH, ScreenW, 0);
        
        
    } completion:^(BOOL finished) {
        
        [_diretoryView removeFromSuperview];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
