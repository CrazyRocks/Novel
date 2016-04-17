//
//  TopCell.m
//  Novel
//
//  Created by John on 16/3/28.
//  Copyright © 2016年 John. All rights reserved.
//

#import "TopCell.h"

@interface TopCell()

@end

@implementation TopCell


/**
 *  男生完结榜
 */

- (IBAction)manEnd_qidian
{
    
}
- (IBAction)manEnd_zongheng
{
    NSLog(@"sss");
}
- (IBAction)manEnd_3g
{
    
}
/**
 *  男生月票榜
 */
- (IBAction)manMonth_qidian
{
    
}
- (IBAction)manMonth_zongheng
{
    
}
- (IBAction)manMonth_17k
{
    
}
- (IBAction)manMonth_tencent
{
    
}
- (IBAction)manMonth_3g
{
    
}
/**
 *  女生完结榜
 */
- (IBAction)girlEnd_qidian
{
    
}
- (IBAction)girlEnd_hongxiu
{
    
}
- (IBAction)girlEnd_yanqing
{
    
}
- (IBAction)girlEnd_xs
{
    
}
- (IBAction)girlEnd_jinjiang
{
    
}
- (IBAction)girlEnd_3g
{
    
}
/**
 *  女生月票榜
 */
- (IBAction)girlMonth_qidian
{
    
}
- (IBAction)girlMonth_hongxiu
{
    
}
- (IBAction)girlMonth_xiaoxiang
{
    
}
- (IBAction)girlMonth_yanqing
{
    
}
- (IBAction)girlMonth_xs
{
    
}
- (IBAction)girlMonth_jinjiang
{
    
}
- (IBAction)girlMonth_3g
{
    
}
/**
 *  男生完结榜
 */
+ (instancetype)manEndWithTableView:(UITableView *)tableView;
{
    static NSString *ID = @"manEnd";
    
    TopCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell)
    {
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"TopCell" owner:nil options:nil] firstObject];
    }
    
    return cell;
}
/**
 *  男生月票榜
 */
+ (instancetype)manMothWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"manMoth";
    
    TopCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell)
    {
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"TopCell" owner:nil options:nil] objectAtIndex:1];
    }
    
    return cell;
}
/**
 *  女生完结榜
 */
+ (instancetype)girlEndWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"girlEnd";
    
    TopCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell)
    {
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"TopCell" owner:nil options:nil] objectAtIndex:2];
    }
    
    return cell;
}
/**
 *  女生月票榜
 */
+ (instancetype)girlMothWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"girlMoth";
    
    TopCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell)
    {
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"TopCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
