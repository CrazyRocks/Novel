//
//  TopViewController.m
//  Novel
//
//  Created by John on 16/3/25.
//  Copyright © 2016年 John. All rights reserved.
//

#import "TopViewController.h"
#import "TopCell.h"

@interface TopViewController ()

@end

@implementation TopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        TopCell *cell = [TopCell manEndWithTableView:tableView];
        return cell;
    }
    if (indexPath.section==1)
    {
        TopCell *cell = [TopCell manMothWithTableView:tableView];
        return cell;
    }
    
    if (indexPath.section==2)
    {
        TopCell *cell = [TopCell girlEndWithTableView:tableView];
        return cell;
    }
    else
    {
        TopCell *cell = [TopCell girlMothWithTableView:tableView];
        return cell;
    }
    
}
/**
 *  cell的高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 147;
    }
    else if (indexPath.section == 1)
    {
        return 183;
    }
    else if (indexPath.section == 2)
    {
        return 183;
    }
    else
    {
        return 264;
    }
}

@end
