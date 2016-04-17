//
//  RankingCell.m
//  Novel
//
//  Created by John on 16/3/27.
//  Copyright © 2016年 John. All rights reserved.
//

#import "RankingCell.h"
#import "RankingBook.h"
#import "UIImageView+WebCache.h"
#import "Public.h"

@interface RankingCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *classLabel;

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;

@end

@implementation RankingCell

+ (instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString *ID = @"ranking";
    RankingCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RankingCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setRankingBook:(RankingBook *)rankingBook
{
    _rankingBook = rankingBook;
    
    self.bookNameLabel.text = rankingBook.title;

//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:rankingBook.coverImage]];
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:rankingBook.coverImage] placeholderImage:[UIImage imageNamed:@"none"]];
    
    self.classLabel.text = rankingBook.category;
    self.authorLabel.text = rankingBook.author;
    self.aboutLabel.text = rankingBook.summary;
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
