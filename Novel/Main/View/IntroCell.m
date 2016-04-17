//
//  IntroCell.m
//  Novel
//
//  Created by John on 16/3/28.
//  Copyright © 2016年 John. All rights reserved.
//
#define filePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"bookShelf.plist"]

#import "IntroCell.h"
#import "RankingBook.h"
#import "UIImageView+WebCache.h"
#import "Public.h"
#import "BookShelfViewController.h"
#import "BookShelf.h"
#import "Single.h"

@interface IntroCell()

@property(nonatomic,strong) Single *single;

@property (weak, nonatomic)  UIImageView *iconView;
@property (weak, nonatomic)  UILabel *authorLabel;
@property (weak, nonatomic)  UILabel *classLabel;
@property (weak, nonatomic)  UILabel *statusLabel;
@property (weak, nonatomic)  UITextView *summary;//简介
@property (weak, nonatomic)  UILabel *numLabel;

@property (weak, nonatomic)  UIButton *addBookShelf;//添加书架
//@property (weak, nonatomic)  UIButton *startReadBtn;//开始阅读

@property (weak, nonatomic)  UIButton *categoryBtn;//查看目录
@end


@implementation IntroCell

- (Single *)single
{
    if (!_single)
    {
        _single = [Single shareSingle];
    }
    return _single;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {

        //封面
        UIImageView *iconView = [[UIImageView alloc] init];
        
        _iconView = iconView;
        [self.contentView addSubview:iconView];
        
        //作者thorX;
        UILabel *authorLabel = [[UILabel alloc] init];
        
        _authorLabel = authorLabel;
        [self.contentView addSubview:authorLabel];
        
        //分类
        UILabel *classLabel = [[UILabel alloc] init];
        
        _classLabel = classLabel;
        [self.contentView addSubview:classLabel];
        
        //状态
        UILabel *statusLabel = [[UILabel alloc] init];
        statusLabel.textColor = [UIColor blackColor
                                 ];
        _statusLabel = statusLabel;
        [self.contentView addSubview:statusLabel];
        
        //在读人数
        UILabel *numLabel = [[UILabel alloc] init];
        
        _numLabel = numLabel;
        [self.contentView addSubview:numLabel];
        
        
        //添加书架
        UIButton *addBookShelf = [[UIButton alloc] init];
        [addBookShelf addTarget:self action:@selector(bookShelf) forControlEvents:UIControlEventTouchDown];
        _addBookShelf = addBookShelf;
        [self.contentView addSubview:addBookShelf];
        
        
        //开始阅读
        UIButton *startRead = [[UIButton alloc] init];
        [startRead addTarget:self action:@selector(startRead) forControlEvents:UIControlEventTouchDown];
        _startReadBtn = startRead;
        [self.contentView addSubview:startRead];
        
        
        //查看目录
        UIButton *categoryBtn = [[UIButton alloc] init];
        [categoryBtn addTarget:self action:@selector(category) forControlEvents:UIControlEventTouchDown];
        _categoryBtn = categoryBtn;
        [self.contentView addSubview:categoryBtn];
        
        //简介
        UITextView *summary = [[UITextView alloc] init];
        
        _summary = summary;
        [self.contentView addSubview:summary];
        
        
    }
    return self;
}


- (void)startRead
{
    [self.delegate startReading];
}
/**
 *  添加到书架
 */
- (void)bookShelf
{
    BookShelf *book = [BookShelf new];
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    if (![mgr fileExistsAtPath:filePath]) //不存在书单
    {
        NSMutableArray *bookShelf = [NSMutableArray array];

        NSMutableDictionary *item = [NSMutableDictionary new];
        
        [item setObject:self.rankingBook.title forKey:@"title"];
        
        NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",self.rankingBook.gid]];
        
        NSString *imageName = [NSString stringWithFormat:@"%@.jpg",self.rankingBook.gid];
        
        [[self imageData] writeToFile:imagePath atomically:YES];//写入
        
        [item setObject:imageName forKey:@"coverImage"];
        [item setObject:self.single.lastChapter forKey:@"lastChapter"];
        [item setObject:self.single.updateTime forKey:@"optimize_update_time"];
        [item setObject:@"1" forKey:@"index"];
        [item setObject:self.rankingBook.gid forKey:@"gid"];
        
        [bookShelf addObject:item];
        
        [bookShelf writeToFile:filePath atomically:YES];
        
        //模型
        book.gid = self.rankingBook.gid;
        book.title = self.rankingBook.title;
        book.coverImage = imageName;
        book.lastChapter = self.single.lastChapter;
        book.updateTIme = self.single.updateTime;
        book.index = @"1";
        
    }
    else
    {
        //存在
        NSMutableArray *bookShelf = [NSMutableArray arrayWithContentsOfFile:filePath];
        
        NSMutableDictionary *item = [NSMutableDictionary new];
        
        [item setObject:self.rankingBook.title forKey:@"title"];
        
        
        NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",self.rankingBook.gid]];
        
         NSString *imageName = [NSString stringWithFormat:@"%@.jpg",self.rankingBook.gid];
        
        [[self imageData] writeToFile:imagePath atomically:YES];//写入
        
        [item setObject:imageName forKey:@"coverImage"];
        
        [item setObject:self.single.lastChapter forKey:@"lastChapter"];
        
        [item setObject:self.single.updateTime forKey:@"optimize_update_time"];
        
        [item setObject:@"1" forKey:@"index"];
        [item setObject:self.rankingBook.gid forKey:@"gid"];
        
        [bookShelf addObject:item];
        
        [bookShelf writeToFile:filePath atomically:YES];
        
        book.gid = self.rankingBook.gid;
        book.title = self.rankingBook.title;
        book.coverImage = imageName;
        book.lastChapter = self.single.lastChapter;
        book.updateTIme = self.single.updateTime;
        book.index = @"1";
    }
    
    //发出通知
    if (self.single.books > 0)
    {
        [self.single.books addObject:book];
    }
    else
    {
        self.single.books = [NSMutableArray arrayWithObject:book];
    }
    
    //保存状态--加入
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:self.rankingBook.title];
    
    self.addBookShelf.enabled = NO;
    [self.addBookShelf setTitle:@"已加入书架" forState:UIControlStateNormal];

}
- (void)category
{
    [self.delegate lookCategory];
}

- (NSData *)imageData
{
    NSData *imageData = nil;
    BOOL isExit = [[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:self.rankingBook.coverImage]];
    if (isExit) {
        NSString *cacheImageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:self.rankingBook.coverImage]];
        if (cacheImageKey.length)
        {
            NSString *cacheImagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:cacheImageKey];
            if (cacheImagePath.length)
            {
                imageData = [NSData dataWithContentsOfFile:cacheImagePath];
            }
        }
    }
    if (!imageData)
    {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.rankingBook.coverImage]];
    }
    return imageData;
}



- (void)setRankingBook:(RankingBook *)rankingBook
{
    _rankingBook = rankingBook;
    
    //设置数据
    [self setupData];
    
    //设置Frame
    [self setupFrame];
}


- (void)setupData
{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.rankingBook.coverImage] placeholderImage:[UIImage imageNamed:@"none"]];
    self.authorLabel.text = self.rankingBook.author;
    self.classLabel.text = self.rankingBook.category;
    self.statusLabel.text = self.rankingBook.status;
    self.numLabel.text = self.rankingBook.reason;
    self.summary.text = self.rankingBook.summary;
    
}
- (void)setupFrame
{
    CGFloat marginX = 8;
    
    //封面
    CGFloat iconX = marginX;
    CGFloat iconY = marginX;
    CGFloat iconW = (ScreenW - marginX * 2) / 3;
    CGFloat iconH = iconW + 10;
    
    self.iconView.frame =CGRectMake(iconX, iconY, iconW, iconH);
    
    
    //作者
    CGFloat margin = 24;
    CGFloat authorX = CGRectGetMaxX(self.iconView.frame) + margin;
    CGFloat authorY = marginX;
    CGFloat authorW = ScreenW - authorX;
    CGFloat authorH = iconH / 4;
    self.authorLabel.font = [UIFont systemFontOfSize:15];
    self.authorLabel.textColor = [UIColor blueColor];
    self.authorLabel.frame = CGRectMake(authorX, authorY, authorW, authorH);
    
    //分类
    CGFloat classX = authorX;
    CGFloat classY = CGRectGetMaxY(self.authorLabel.frame);
    CGFloat classW = authorW;
    CGFloat classH = authorH;
    self.classLabel.font = [UIFont systemFontOfSize:14];
    self.classLabel.textColor = [UIColor lightGrayColor];
    self.classLabel.frame = CGRectMake(classX, classY, classW, classH);
    
    //状态
    CGFloat statusX = classX;
    CGFloat statusY = CGRectGetMaxY(self.classLabel.frame);
    CGFloat statusW = classW;
    CGFloat statusH = classH;
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.textColor = [UIColor lightGrayColor];
    self.statusLabel.frame = CGRectMake(statusX, statusY, statusW, statusH);
    
    
    //在读人数
    CGFloat numX = statusX;
    CGFloat numY = CGRectGetMaxY(self.statusLabel.frame);
    CGFloat numW = statusW;
    CGFloat numH = statusH;
    self.numLabel.font = [UIFont systemFontOfSize:14];
    self.numLabel.textColor = [UIColor lightGrayColor];
    self.numLabel.frame = CGRectMake(numX, numY, numW, numH);
    
    
    //添加书架
    CGFloat addX = CGRectGetMinX(self.iconView.frame);
    CGFloat addY = CGRectGetMaxY(self.iconView.frame) + margin;
    CGFloat addW = (ScreenW - marginX * 2 - margin) * 0.5;
    CGFloat addH = 30;
    self.addBookShelf.frame = CGRectMake(addX, addY, addW, addH);
    
    self.addBookShelf.layer.borderWidth = 1;
    self.addBookShelf.layer.borderColor = [UIColor redColor].CGColor;
    
    //判断是否加入了书架
    if ([[NSUserDefaults standardUserDefaults] boolForKey:self.rankingBook.title])
    {
        //已经加入
        self.addBookShelf.enabled = NO;
        [self.addBookShelf setTitle:@"已加入书架" forState:UIControlStateNormal];
    }
    else
    {
        //没有加入
        [self.addBookShelf setTitle:@"加入书架" forState:UIControlStateNormal];
    }
    [self.addBookShelf setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.addBookShelf.backgroundColor = [UIColor whiteColor];
    
    
    //开始阅读
    CGFloat startX = CGRectGetMaxX(self.addBookShelf.frame) + margin;
    CGFloat startY = addY;
    CGFloat startW = addW;
    CGFloat startH = addH;
    self.startReadBtn.frame = CGRectMake(startX, startY, startW, startH);
    
    
    //判断是否加入了书架
    if ([[NSUserDefaults standardUserDefaults] boolForKey:self.rankingBook.title])
    {
        //已经加入
        NSMutableArray *dictArray = [NSMutableArray arrayWithContentsOfFile:filePath];
        
        NSMutableArray *array = [NSMutableArray array];
        
        [dictArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            BookShelf *books = [BookShelf bookShelfWithDict:obj];
            
            if ([books.title isEqualToString:self.rankingBook.title])
            {
                [array addObject:books.index];
            }
            
        }];
        
        self.single.index = [[array lastObject] integerValue];
        
        [self.startReadBtn setTitle:@"继续阅读" forState:UIControlStateNormal];
        
    }
    else
    {
        [self.startReadBtn setTitle:@"开始阅读" forState:UIControlStateNormal];
    }
    
    
    [self.startReadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.startReadBtn.backgroundColor = Color(193, 0, 32);
    
    //查看目录
    CGFloat categoryX = marginX;
    CGFloat categoryY = CGRectGetMaxY(self.startReadBtn.frame) + margin;
    CGFloat categoryW = ScreenW - marginX * 2;
    CGFloat categoryH = 30;
    self.categoryBtn.frame = CGRectMake(categoryX, categoryY, categoryW, categoryH);
    
    self.categoryBtn.layer.borderWidth = 1;
    self.categoryBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self.categoryBtn setTitle:@"查看目录" forState:UIControlStateNormal];
    self.categoryBtn.backgroundColor = [UIColor whiteColor];
    [self.categoryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    //简介
    CGFloat summaryX = marginX;
    CGFloat summaryY = CGRectGetMaxY(self.categoryBtn.frame) + marginX;
    CGFloat summaryW = categoryW;
    CGFloat summaryH = ScreenH - summaryY;
    
    self.summary.frame = CGRectMake(summaryX, summaryY, summaryW, summaryH);
    self.summary.textAlignment = NSTextAlignmentLeft;
    self.summary.textColor = [UIColor blackColor];
    self.summary.font = [UIFont fontWithName:@"STHeitiSC-Light" size:17.f];
    self.summary.userInteractionEnabled = NO;
}



+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"about";
    IntroCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"IntroCell" owner:nil options:nil] firstObject];
        cell = [[IntroCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
