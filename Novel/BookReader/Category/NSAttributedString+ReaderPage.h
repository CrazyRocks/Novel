//
//  NSAttributedString+ReaderPage.h
//  Novel
//
//  Created by John on 16/3/21.
//  Copyright © 2016年 John. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSAttributedString (ReaderPage)

// 根据渲染图文大小分页，返回range数组

- (NSArray *)pageRangeArrayWithConstrainedToSize:(CGSize)size;

@end
