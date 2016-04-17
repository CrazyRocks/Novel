//
//  ReadingViewController.h
//  Novel
//
//  Created by John on 16/4/2.
//  Copyright © 2016年 John. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReadingViewController;

@protocol readingViewControllerDelegate <NSObject>

@optional

- (void)reloadData:(ReadingViewController *)readVC;

@end


@interface ReadingViewController : UIViewController

@property(nonatomic,weak) id<readingViewControllerDelegate> delegate;

@property(nonatomic,assign) NSInteger index;

- (void)jumpDir:(NSInteger)index;

- (void)closeView;

@end
