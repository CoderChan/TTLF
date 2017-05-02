//
//  BookTableHeadView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/2.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "BookTableHeadView.h"
#import <Masonry.h>

@interface BookTableHeadView ()

/** 书本的封面 */
@property (strong,nonatomic) UIImageView *bookCoverImgView;
/** 书本的名称 */
@property (strong,nonatomic) UILabel *bookNameLabel;
/** 作者 */
@property (strong,nonatomic) UILabel *bookWriterLabel;
/** 类型 */
@property (strong,nonatomic) UILabel *bookTypeLabel;

@end

@implementation BookTableHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 线
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    xian.frame = CGRectMake(0, self.height - 1, self.width, 2);
    [self addSubview:xian];
    // 封面
    self.bookCoverImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gy_book_cell"]];
    self.bookCoverImgView.frame = CGRectMake(15, 15, 90, 110);
    [self addSubview:self.bookCoverImgView];
    
    
    // 图名称
    self.bookNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bookCoverImgView.x + self.bookCoverImgView.width + 10, 23, self.width - (self.bookCoverImgView.x + self.bookCoverImgView.width + 10) - 10, 42)];
    self.bookNameLabel.text = @"《法华经》";
    self.bookWriterLabel.numberOfLines = 2;
    self.bookNameLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.bookNameLabel];
    
    
    // 作者
    self.bookWriterLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bookNameLabel.x, CGRectGetMaxY(self.bookNameLabel.frame) + 5, self.bookNameLabel.width, 21)];
    self.bookWriterLabel.text = @"作者：起源于古印度（佚名）";
    self.bookWriterLabel.font = [UIFont systemFontOfSize:15];
    self.bookWriterLabel.textColor = [UIColor grayColor];
    [self addSubview:self.bookWriterLabel];
    
    
    // 类型
    self.bookTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bookNameLabel.x, CGRectGetMaxY(self.bookWriterLabel.frame), self.bookNameLabel.width, 21)];
    self.bookTypeLabel.text = @"类型：古经原文";
    self.bookTypeLabel.font = self.bookWriterLabel.font;
    self.bookTypeLabel.textColor = [UIColor grayColor];
    [self addSubview:self.bookTypeLabel];
    
    // 简介
    
}

@end
