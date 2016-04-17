//
//  IntroCell.h
//  Novel
//
//  Created by John on 16/3/28.
//  Copyright © 2016年 John. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RankingBook;


@protocol IntroCellDelegate <NSObject>

@optional

- (void)lookCategory;
- (void)startReading;

@end


@interface IntroCell : UITableViewCell

@property(nonatomic,strong) RankingBook *rankingBook;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic)  UIButton *startReadBtn;//开始阅读

@property(nonatomic,weak) id<IntroCellDelegate> delegate;

@end
