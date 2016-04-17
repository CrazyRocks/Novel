//
//  BookShelfCell.m
//  Novel
//
//  Created by John on 16/4/11.
//  Copyright © 2016年 John. All rights reserved.
//
// 正文的字体
#define TitleFont [UIFont systemFontOfSize:14]
#define UpdateFont [UIFont systemFontOfSize:12]

#import "BookShelfCell.h"
#import "Public.h"

@interface BookShelfCell()

@property(nonatomic,weak) UIImageView *iconView;

@property(nonatomic,weak) UIImageView *updateView;

@property(nonatomic,weak) UILabel *titleLabel;

@property(nonatomic,weak) UILabel *lastLabel;

@end

@implementation BookShelfCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //封面
        UIImageView *iconView = [[UIImageView alloc] init];
        _iconView = iconView;
        [self.contentView addSubview:iconView];
        
        //是否更新了
        UIImageView *updateView = [[UIImageView alloc] init];
        _updateView = updateView;
        [self.contentView addSubview:updateView];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = TitleFont;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel = titleLabel;
        [self.contentView addSubview:titleLabel];
        
        //最后更新
        UILabel *lastLabel = [[UILabel alloc] init];
        lastLabel.font = UpdateFont;
        lastLabel.textColor = [UIColor lightGrayColor];
//        lastLabel.numberOfLines = 0;
        lastLabel.textAlignment = NSTextAlignmentLeft;
        _lastLabel = lastLabel;
        [self.contentView addSubview:lastLabel];
    }
    return self;
}


- (void)setBookShelf:(BookShelf *)bookShelf
{
    _bookShelf = bookShelf;
    
    [self setupData];
    
    [self setupFrame];
}

- (void)setupData
{
    NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:self.bookShelf.coverImage];
    self.iconView.image = [UIImage imageWithContentsOfFile:imagePath];
    
    self.updateView.image = [UIImage imageNamed:@"update_image"];
    
    self.titleLabel.text = self.bookShelf.title;
    
    self.lastLabel.text = [NSString stringWithFormat:@"%@更新：%@",[self getUTCFormateDate],self.bookShelf.lastChapter];
    
}

//计算  距离现在的时间
-(NSString *)getUTCFormateDate
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *lastTime = [NSDate dateWithTimeIntervalSince1970:[self.bookShelf.updateTIme intValue]];
    
    NSString *newsDate = [formatter stringFromDate:lastTime];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *newsDateFormatted = [dateFormatter dateFromString:newsDate];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    [dateFormatter setTimeZone:timeZone];
    
    
    
    NSDate *current_date = [[NSDate alloc] init]; //当前时间
    
    NSTimeInterval time=[current_date timeIntervalSinceDate:newsDateFormatted];//间隔的秒数
    
    int month=((int)time)/(3600*24*30);
    
    int days=((int)time)/(3600*24);
    
    int hours=((int)time)%(3600*24)/3600;
    
    int minute=((int)time)%(3600*24)/60;
    
    NSString *dateContent;
    
    
    if(month!=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"",month,@"个月前"];
        
    }else if(days!=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"",days,@"天前"];
        
    }else if(hours!=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"",hours,@"小时前"];
        
    }else if(minute !=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"",minute,@"分钟前"];
    }else
        
    {
        dateContent =@"刚刚";
    }
    
    return dateContent;
    
}
- (void)setupFrame
{
    self.frame = CGRectMake(0, 0, ScreenW, 60);
    
    CGFloat marginX = 10;
    CGFloat marginY = 5;
    //封面
    CGFloat iconX = marginX;
    CGFloat iconY = marginY;
    CGFloat iconH = self.frame.size.height - marginY * 2;
    CGFloat iconW = iconH * 0.8;
    self.iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    
    //标题
    CGSize titleSize = [self sizeWithText:self.bookShelf.title font:TitleFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat titleX = CGRectGetMaxX(self.iconView.frame) + marginX;
    CGFloat titleY = CGRectGetMinY(self.iconView.frame);
    
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleSize.width, titleSize.height);
    
    //更新
    CGFloat updateX = CGRectGetMaxX(self.titleLabel.frame) + marginX;
    CGFloat updateY = titleY;
    CGFloat updateW = titleSize.height*1.5;
    CGFloat updateH = titleSize.height * 0.8;
    self.updateView.frame = CGRectMake(updateX, updateY, updateW, updateH);
    
    //最后一章
    CGFloat lastW = ScreenW - CGRectGetMinX(self.titleLabel.frame);
    CGFloat lastH = titleSize.height;
    CGFloat lastX = titleX;
    CGFloat lastY = CGRectGetMaxY(self.iconView.frame) - lastH;
    self.lastLabel.frame = CGRectMake(lastX, lastY, lastW, lastH);
    
}
/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"bookShelf";
    BookShelfCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[BookShelfCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
