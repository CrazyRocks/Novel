//
//  TopCell.h
//  Novel
//
//  Created by John on 16/3/28.
//  Copyright © 2016年 John. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopCell : UITableViewCell
/**
 *  男生完结榜
 */
+ (instancetype)manEndWithTableView:(UITableView *)tableView;
/**
 *  男生月票榜
 */
+ (instancetype)manMothWithTableView:(UITableView *)tableView;
/**
 *  女生完结榜
 */
+ (instancetype)girlEndWithTableView:(UITableView *)tableView;
/**
 *  女生月票榜
 */
+ (instancetype)girlMothWithTableView:(UITableView *)tableView;

@end
