//
//  ReaderToolBar.h
//  Novel
//
//  Created by John on 16/3/22.
//  Copyright © 2016年 John. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReaderToolBar;

@protocol ReaderToolBarDelegate <NSObject>

@optional

-(void)readerToolBarDelegate:(ReaderToolBar *)toolBar didSelectButton:(NSInteger)tag;

@end

@interface ReaderToolBar : UIView

@property(nonatomic,weak) id<ReaderToolBarDelegate> delegate;

@end
