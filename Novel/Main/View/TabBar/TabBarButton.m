//
//  TabBarButton.m
//  Note
//
//  Created by John on 15/12/30.
//  Copyright © 2015年 John. All rights reserved.
//

#import "TabBarButton.h"

@implementation TabBarButton
/**
 *  只要覆盖了这个方法，按钮就不存在高亮状态
 *
 *  @param highlighted <#highlighted description#>
 */
-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
}

@end
