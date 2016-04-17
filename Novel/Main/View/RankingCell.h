//
//  RankingCell.h
//  Novel
//
//  Created by John on 16/3/27.
//  Copyright © 2016年 John. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RankingBook;

@interface RankingCell : UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableview;


@property(nonatomic,strong) RankingBook *rankingBook;


@end
