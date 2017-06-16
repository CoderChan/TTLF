//
//  MyBooksTableViewCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/2.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MyBooksTableViewCell.h"
#import <Masonry.h>

@interface MyBooksTableViewCell ()

/** 书本的封面 */
@property (strong,nonatomic) UIImageView *bookCoverImgView;
/** 书本的名称 */
@property (strong,nonatomic) UILabel *bookNameLabel;
/** 书本简介 */
@property (strong,nonatomic) UILabel *bookDescLabel;

@end

@implementation MyBooksTableViewCell

+ (instancetype)sharedBookTableViewCell:(UITableView *)tableView
{
    static NSString *ID = @"MyBooksTableViewCell";
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    MyBooksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MyBooksTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupSubVies];
    }
    return self;
}

- (void)setModel:(BookInfoModel *)model
{
    _model = model;
    [_bookCoverImgView sd_setImageWithURL:[NSURL URLWithString:model.book_logo] placeholderImage:[UIImage imageNamed:@"gy_book_cell"]];
    _bookNameLabel.text = [NSString stringWithFormat:@"《%@》",model.book_name];
    _bookDescLabel.text = model.book_type;
}

- (void)setupSubVies
{
    // 背景
    UIImageView *backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BookShelfCell"]];
    backImage.frame = self.bounds;
    [self.contentView addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    
    // 书本封面
    self.bookCoverImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gy_book_cell"]];
    self.bookCoverImgView.backgroundColor = [UIColor clearColor];
    [backImage addSubview:self.bookCoverImgView];
    [self.bookCoverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImage.mas_left).offset(23);
        make.top.equalTo(backImage.mas_top).offset(15);
        make.bottom.equalTo(backImage.mas_bottom).offset(-20);
        make.width.equalTo(@90);
    }];
    
    
    // 书本名称
    self.bookNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.bookNameLabel.text = @"《法华经》";
    self.bookNameLabel.textColor = [UIColor whiteColor];
    self.bookNameLabel.font = [UIFont boldSystemFontOfSize:20];
    [backImage addSubview:self.bookNameLabel];
    [self.bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bookCoverImgView.mas_right).offset(10);
        make.bottom.equalTo(self.bookCoverImgView.mas_centerY);
        make.height.equalTo(@24);
        make.right.equalTo(backImage.mas_right).offset(-15);
    }];
    
    // 书本简介
    self.bookDescLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.bookDescLabel.text = @"法华经简介简介简介简介简介简介简介简介简介简介";
    self.bookDescLabel.textColor = [UIColor whiteColor];
    self.bookDescLabel.numberOfLines = 2;
    self.bookDescLabel.font = [UIFont systemFontOfSize:15];
    [backImage addSubview:self.bookDescLabel];
    [self.bookDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bookNameLabel.mas_left).offset(8);
        make.top.equalTo(self.bookNameLabel.mas_bottom);
        make.height.equalTo(@42);
        make.right.equalTo(backImage.mas_right).offset(-20);
    }];
    
}


@end
