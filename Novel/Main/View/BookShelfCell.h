//
//  BookShelfCell.h
//  Novel
//
//  Created by John on 16/4/11.
//  Copyright © 2016年 John. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookShelf.h"


@interface BookShelfCell : UITableViewCell


@property(nonatomic,strong) BookShelf *bookShelf;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
/**
 *  cell的高度
 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;
@end
