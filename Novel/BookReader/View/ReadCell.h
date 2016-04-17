//
//  ReadCell.h
//  Novel
//
//  Created by John on 16/4/4.
//  Copyright © 2016年 John. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contents.h"
#import "BookChapter.h"

@interface ReadCell : UITableViewCell

/**
 *  具体哪本书
 */
@property(nonatomic,assign) NSInteger index;

@property(nonatomic,strong) Contents *content;

@property(nonatomic,strong) BookChapter *bookChapter;


@end
