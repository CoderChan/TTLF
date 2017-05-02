//
//  BookStoreTableViewCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/2.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "BookStoreTableViewCell.h"
#import <Masonry.h>

@interface BookStoreTableViewCell ()

/** 书本的封面 */
@property (strong,nonatomic) UIImageView *bookCoverImgView;
/** 书本的名称 */
@property (strong,nonatomic) UILabel *bookNameLabel;
/** 书本简介 */
@property (strong,nonatomic) UILabel *bookDescLabel;

@end

@implementation BookStoreTableViewCell

+ (instancetype)sharedBookStoreCell:(UITableView *)tableView
{
    static NSString *ID = @"BookStoreTableViewCell";
    BookStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BookStoreTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    self.bookCoverImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gy_book_cell"]];
    [self.contentView addSubview:self.bookCoverImgView];
    [self.bookCoverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.equalTo(@90);
    }];
    
    // 书本名称
    self.bookNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.bookNameLabel.text = @"《法华经》";
    self.bookNameLabel.textColor = RGBACOLOR(25, 25, 30, 1);
    self.bookNameLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.contentView addSubview:self.bookNameLabel];
    [self.bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bookCoverImgView.mas_right).offset(8);
        make.bottom.equalTo(self.bookCoverImgView.mas_centerY).offset(-8);
        make.height.equalTo(@24);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    // 书本简介
    self.bookDescLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.bookDescLabel.text = @"法华经简介简介简介简介简介简介简介简介简介简介";
    self.bookDescLabel.textColor = RGBACOLOR(45, 45, 45, 1);
    self.bookDescLabel.numberOfLines = 2;
    self.bookDescLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.bookDescLabel];
    [self.bookDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bookNameLabel.mas_left);
        make.top.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@42);
        make.right.equalTo(self.contentView.mas_right);
    }];
    
}

@end
