//
//  ReadCell.m
//  Novel
//
//  Created by John on 16/4/4.
//  Copyright © 2016年 John. All rights reserved.
//
#define filePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"bookShelf.plist"]
#define myStatusBar @"myStatusBar"


#import "ReadCell.h"
#import "JDStatusBarNotification.h"
#import "Single.h"
#import "Public.h"

@interface ReadCell()

@property(nonatomic,strong) Single *single;
@property(nonatomic,strong) NSMutableArray *bookShelf;
@property(nonatomic,strong) NSMutableDictionary *item;

@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UIImageView *contentImageView;

@end


@implementation ReadCell

- (Single *)single
{
    if (!_single)
    {
        _single = [Single shareSingle];
    }
    return _single;
}


- (void)setContent:(Contents *)content
{
    _content = content;
    
    self.contentLabel.text = content.chapter;
    self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:17.f];
}
- (void)setBookChapter:(BookChapter *)bookChapter
{
    _bookChapter = bookChapter;
    [JDStatusBarNotification showWithStatus:bookChapter.text styleName:myStatusBar];//状态栏
    
    [_item setValue:bookChapter.index forKey:@"index"];
    
    self.single.index = [bookChapter.index integerValue];//章节的index标记
    
    [_bookShelf writeToFile:filePath atomically:YES];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat totalHeight = 0;
    totalHeight += [self.contentLabel sizeThatFits:size].height;
    //    totalHeight += [self.contentImageView sizeThatFits:size].height;
    totalHeight += 40; // margins
    return CGSizeMake(size.width, totalHeight);
}
- (void)awakeFromNib
{
    // Initialization code
     self.contentView.bounds = [UIScreen mainScreen].bounds;
    
    _bookShelf = [NSMutableArray arrayWithContentsOfFile:filePath];
    _item = [_bookShelf objectAtIndex:self.single.indexBook];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
