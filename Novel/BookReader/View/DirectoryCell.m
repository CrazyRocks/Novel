//
//  DirectoryCell.m
//  Novel
//
//  Created by John on 16/4/4.
//  Copyright © 2016年 John. All rights reserved.
//

#import "DirectoryCell.h"

@interface DirectoryCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

@property (weak, nonatomic) IBOutlet UILabel *directoryLabel;

@end

@implementation DirectoryCell

- (void)setDirectory:(BookChapter *)directory
{
    _directory = directory;
    
    self.iconView.image = [UIImage imageNamed:@"directory_not_previewed"];
    
    self.indexLabel.text = [NSString stringWithFormat:@"%@",directory.index];;
    
    self.directoryLabel.text = directory.text;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"directory";
    DirectoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell  =[[[NSBundle mainBundle] loadNibNamed:@"DirectoryCell" owner:nil options:nil] lastObject];
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
