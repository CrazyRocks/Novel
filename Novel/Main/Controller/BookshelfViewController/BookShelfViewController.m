//
//  BookShelfViewController.m
//  Novel
//
//  Created by John on 16/4/11.
//  Copyright © 2016年 John. All rights reserved.
//
#define filePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"bookShelf.plist"]

#import "BookShelfViewController.h"
#import "IntroCell.h"
#import "Public.h"
#import "BookShelf.h"
#import "BookShelfCell.h"
#import "IntroCell.h"
#import "Single.h"
#import "ReadingViewController.h"

@interface BookShelfViewController ()<UITableViewDelegate,UITableViewDataSource,readingViewControllerDelegate>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *bookList;

@property(nonatomic,strong) Single *single;

@property(nonatomic,strong) ReadingViewController *read;

@end

@implementation BookShelfViewController

- (Single *)single
{
    if (!_single)
    {
        _single = [Single shareSingle];
    }
    return _single;
}

- (NSMutableArray *)bookList
{
    if (!_bookList)
    {
        NSMutableArray *dictArray = [NSMutableArray arrayWithContentsOfFile:filePath];
        
        NSMutableArray *bookArray = [NSMutableArray array];
        
        //获取Documents文件夹下所有的文件名
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSArray *fileNameList=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:docPath error:nil];
        
        NSMutableArray *bookShelf = [NSMutableArray array];
        
        for (NSDictionary *dict in dictArray)
        {
            BookShelf *book = [BookShelf bookShelfWithDict:dict];
            [bookArray addObject:book];
            [bookShelf addObject:[NSString stringWithFormat:@"%@.plist",book.title]];
            [bookShelf addObject:book.coverImage];
        }
        _bookList = bookArray;
        
        [bookShelf addObjectsFromArray:fileNameList];
        [bookShelf addObject:@"bookShelf.plist"]; //书单不能删除
        
        NSMutableArray *dateMutablearray = [NSMutableArray array];
        
        for (int i = 0; i < bookShelf.count; i++)
        {
            NSString *string = bookShelf[i];
            
            NSMutableArray *tempArray = [@[] mutableCopy];
            
            [tempArray addObject:string];
            
            for (int j = i+1; j < bookShelf.count; j ++)
            {
                NSString *jstring = bookShelf[j];
                
                if([string isEqualToString:jstring])
                {
                    [tempArray addObject:jstring];
                    
                    // [array removeObjectAtIndex:j]; //内循环做删除行为 导致总对比次数不完整 此动作应在循环外处理
                    
                }
                
            }
            if ([tempArray count] > 1)
            {
                
                [dateMutablearray addObject:tempArray];
                
                [bookShelf removeObjectsInArray:tempArray];
                
                i -= 1;    //去除重复数据 新数组开始遍历位置不变
            }
        }
        //删除不是书架的数据文件
        NSFileManager *mgr = [NSFileManager defaultManager];
        for (int i = 0; i < bookShelf.count; i++)
        {
            NSString *fileName = [docPath stringByAppendingPathComponent:bookShelf[i]];
            [mgr removeItemAtPath:fileName error:nil];
        }
        
        
    }
    return _bookList;
}
- (void)setupTableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.tableView.rowHeight = 60;
        [self.view addSubview:_tableView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTableView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;  //导航栏的背景色是黑色
    
    self.single.isAtIntroVc = NO;
    
    if (!self.single.books) return; //如果为空直接返回
    
    if (self.bookList.count > 0)
    {
        [self.bookList addObjectsFromArray:self.single.books];
        
        [self.tableView reloadData];
    }
    else
    {
        self.bookList = [NSMutableArray arrayWithArray:self.single.books];
        [self.tableView reloadData];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.single.books removeAllObjects];
    self.single.books = nil;
}

- (void)reloadTableView:(NSNotification *)notification
{
    NSMutableArray *books = [notification object];
    if (self.bookList.count > 0)
    {
        [self.bookList addObjectsFromArray:books];
    }
    else
    {
        self.bookList = [NSMutableArray arrayWithArray:books];
    }
    
    [self.tableView reloadData];
}

#pragma mark - tableVieaDateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bookList.count;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookShelfCell *cell = [BookShelfCell cellWithTableView:tableView];
    
    BookShelf *bookShelf = self.bookList[indexPath.row];
    cell.bookShelf = bookShelf;
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_selected_background"]];
    return cell;
}

#pragma mark - 左滑删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self setData];
        
        //1.改变加入书架按钮状态
        BookShelf *books = self.bookList[indexPath.row];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:books.title];
        
        //2.删除模型数据
        [self.bookList removeObjectAtIndex:indexPath.row];
        
        //3.删除plist数据
        NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        
        
        NSString *bookPath =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",books.title]];
        
        NSString *coverImagePath =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",books.gid]];
        
        //删除保存的index章节标记
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@%@",books.title,token]];
        
        NSFileManager *mgr = [NSFileManager defaultManager];
        if ([mgr fileExistsAtPath:bookPath])
        {
            //存在
            [mgr removeItemAtPath:bookPath error:nil];
        }
        if ([mgr fileExistsAtPath:coverImagePath])
        {
            //存在
            [mgr removeItemAtPath:coverImagePath error:nil];
        }
        
        [array removeObjectAtIndex:indexPath.row];
        
        [array writeToFile:filePath atomically:YES];
        
        //4.刷新
        [self.tableView reloadData];
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ReadingViewController *read = [ReadingViewController new];
    
    
    read.delegate = self;
    
    BookShelf *bookShelf = self.bookList[indexPath.row];
    
    read.index = [bookShelf.index integerValue] - 1;
    
    self.single.title = bookShelf.title;
    self.single.indexBook = indexPath.row;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:read];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)reloadData:(ReadingViewController *)readVC
{
    [self setData];
}
/**
 *  重新加载数据
 */
- (void)setData
{
    [self.bookList removeAllObjects];
    self.bookList = nil;
    
    NSMutableArray *dictArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *bookArray = [NSMutableArray array];
    
    for (NSDictionary *dict in dictArray)
    {
        BookShelf *book = [BookShelf bookShelfWithDict:dict];
        [bookArray addObject:book];
    }
    
    _bookList = bookArray;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
