//
//  ReaderTop.h
//  Novel
//
//  Created by John on 16/4/7.
//  Copyright © 2016年 John. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReaderTopDelegate <NSObject>

@optional

- (void)backBVc;

@end

@interface ReaderTop : UIView


@property (weak, nonatomic) IBOutlet UILabel *label;


@property(nonatomic,weak) id<ReaderTopDelegate> delegate;

@end
