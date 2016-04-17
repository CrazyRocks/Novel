//
//  IntroViewController.h
//  Novel
//
//  Created by John on 16/3/28.
//  Copyright © 2016年 John. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RankingBook;

@interface IntroViewController : UITableViewController

@property(nonatomic,strong) RankingBook *rankingBook;

- (void)closeView;

@end
