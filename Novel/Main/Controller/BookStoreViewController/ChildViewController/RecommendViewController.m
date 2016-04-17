//
//  RecommendViewController.m
//  Novel
//
//  Created by John on 16/3/25.
//  Copyright © 2016年 John. All rights reserved.
//

#import "RecommendViewController.h"
#import "Public.h"
#import "RankingBook.h"
#import "MJRefresh.h"
#import "AFNetworkTool.h"


@interface RecommendViewController ()

//@property (strong,nonatomic) NSMutableArray *recommendList;

//@property(nonatomic,assign) int index;

@end

@implementation RecommendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.index = 2;
    
    [self setupRefresh];
    
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
    
    NSString *url = @"http://m.baidu.com/book/data/recommend?pn=1";
    
    [RankingBook getURLString:url objectString:@"result" arrayString:@"recommend" successWithSummary:^(NSArray *summaryList) {
        
        self.rankingList = [NSMutableArray arrayWithArray:summaryList];
        
        [self.tableView reloadData];
        
        //停止刷新
        [self.tableView.mj_header endRefreshing];
        
        self.tableView.mj_footer.hidden = NO;
        
    }  error:^(NSError *error) {
        
    }];
}

/**
 *  加载更多
 */
- (void)loadMore
{
    NSString *urlString = [NSString stringWithFormat:@"http://m.baidu.com/book/data/recommend?pn=%d",self.index];//1-25
    
    NSString *url = urlString;
    
    self.index ++;
    
    if (self.index>25)
    {
        
        return;
    }
    
    [RankingBook getURLString:url objectString:@"result" arrayString:@"recommend" successWithSummary:^(NSArray *summaryList) {
        
        [self.rankingList addObjectsFromArray:summaryList];
        [self.tableView reloadData];
        
        //停止刷新
        [self.tableView.mj_header endRefreshing];
        
        self.tableView.mj_footer.hidden = NO;
        
    } error:^(NSError *error) {
        
        
    }];
    
    
    //刷新
    [self.tableView reloadData];
    
    [self.tableView.mj_footer endRefreshing]; //停止刷新
}


@end
