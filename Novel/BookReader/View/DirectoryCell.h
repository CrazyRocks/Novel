//
//  DirectoryCell.h
//  Novel
//
//  Created by John on 16/4/4.
//  Copyright © 2016年 John. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookChapter.h"

@interface DirectoryCell : UITableViewCell

@property(nonatomic,strong) BookChapter *directory;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
