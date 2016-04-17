//
//  RankingViewController.m
//  Novel
//
//  Created by John on 16/3/25.
//  Copyright © 2016年 John. All rights reserved.
//

#import "RankingViewController.h"
#import "Public.h"
#import "MJRefresh.h"
#import "AFNetworkTool.h"
#import "RankingCell.h"
#import "RankingBook.h"
#import "IntroViewController.h"

@interface RankingViewController ()

//@property (strong,nonatomic) NSMutableArray *rankingList;
//
//@property(nonatomic,assign) int index;

@end

@implementation RankingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupRefresh];
    
    _index = 2;
}

- (void)setupRefresh
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRanking)];
    
    //开始刷新
    [self.tableView.mj_header beginRefreshing];
    
    //加载更多
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    //加载完后隐藏刷新条
    self.tableView.mj_footer.hidden = YES;
}
/**
 *  加载
 */
- (void)loadRanking
{
    
    NSString *url = @"http://m.baidu.com/book/data/rank?pn=1";
    
    [RankingBook getURLString:url objectString:@"result" arrayString:@"rank" successWithSummary:^(NSArray *summaryList) {
        
        self.rankingList = [NSMutableArray arrayWithArray:summaryList];
        
        [self.tableView reloadData];
        
        //停止刷新
        [self.tableView.mj_header endRefreshing];
        
        self.tableView.mj_footer.hidden = NO;
        
    } error:^(NSError *error) {
        
    }];

}

/**
 *  加载更多
 */
- (void)loadMore
{
    NSString *url = [NSString stringWithFormat:@"http://m.baidu.com/book/data/rank?pn=%d",_index];//1-50
    
    _index ++;
    
    if (_index>50)
    {
        //没有了
        return;
    }
    
    [RankingBook getURLString:url objectString:@"result" arrayString:@"rank" successWithSummary:^(NSArray *summaryList) {
        
        [self.rankingList addObjectsFromArray:summaryList];
        
    } error:^(NSError *error) {
        
    }];
    
    
    self.tableView.mj_footer.hidden = NO;
    //停止刷新
    [self.tableView.mj_header endRefreshing];
    
    //刷新
    [self.tableView reloadData];
    
    [self.tableView.mj_footer endRefreshing]; //停止刷新
}

#pragma dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rankingList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RankingCell *cell = [RankingCell cellWithTableView:tableView];
    
    RankingBook *rankingBook = self.rankingList[indexPath.row];
    
    cell.rankingBook = rankingBook;
    
    return cell;
    
}

#pragma delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RankingBook *ranking = self.rankingList[indexPath.row];
    
    
//    NSString *url = [NSString stringWithFormat:@"http://m.baidu.com/tc?ajax=1&appui=alaxs&dir=1&gid=%@",ranking.gid];
    
    IntroViewController *intro = [IntroViewController new];
    
    intro.rankingBook = ranking;
    
    [self.navigationController pushViewController:intro animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


@end
