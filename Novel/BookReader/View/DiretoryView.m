//
//  DiretoryView.m
//  Novel
//
//  Created by John on 16/4/9.
//  Copyright © 2016年 John. All rights reserved.
//

#import "DiretoryView.h"
#import "Public.h"
#import "Single.h"
#import "DirectoryCell.h"
#import "ReadingViewController.h"
#import "IntroViewController.h"

@interface DiretoryView()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSMutableArray *totolList; //总章节

@property(nonatomic,strong) Single *single;

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) UIButton *orderBtn;//排序

@property(nonatomic,assign) BOOL isOrder;

@end

@implementation DiretoryView

- (instancetype)initWithDirtoryView
{
    if (self = [super init])
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [self addSubview:_tableView];
        
        [self addSubview:self.orderBtn];
    }
    return self;
}

-(UIButton *)orderBtn
{
    if (!_orderBtn)
    {
        _orderBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.8, [UIScreen mainScreen].bounds.size.height * 0.7, 50, 50)];
        [_orderBtn setBackgroundImage:[UIImage imageNamed:@"reading_dir_seq"] forState:UIControlStateNormal];
        [_orderBtn addTarget:self action:@selector(orderTarget) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderBtn;
}
-(void)orderTarget
{
    if (_isOrder == NO)
    {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_isOrder == 0 ? self.totolList.count-1 : 0  inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        _isOrder = YES;
    }
    else
    {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_isOrder == 0 ? self.totolList.count-1 : 0  inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        _isOrder = NO;
    }
}

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.totolList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DirectoryCell *cell = [DirectoryCell cellWithTableView:tableView];
    
    BookChapter *directory = self.totolList[indexPath.row];
    cell.directory = directory;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IntroViewController *intro = (IntroViewController *)self.nextResponder.nextResponder;//响应者链关系
    
    ReadingViewController *read = [ReadingViewController new];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:0.0f forKey:[NSString stringWithFormat:@"%@%@",self.single.title,token]];
    
    [defaults synchronize];
    
    if (self.single.isAtIntroVc==YES)//简介界面
    {
        read.index = indexPath.row;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:read];
        
        [intro.navigationController presentViewController:nav animated:YES completion:^{
            
            [intro closeView];
            [self removeFromSuperview];
            
        }];
    }
    else
    {
        //不是在简介界面
        ReadingViewController *reading = (ReadingViewController *)self.nextResponder.nextResponder;
        
        [reading closeView];
        self.single.isReadAtDirView = YES;
        
        NSString *index = [NSString stringWithFormat:@"%ld",indexPath.row];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:index,@"indexPath",nil];
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dirtory" object:nil userInfo:dict];
        
        [self removeFromSuperview];
        
    }
    
}












@end
