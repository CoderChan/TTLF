//
//  StoreTableViewCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/21.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "StoreTableViewCell.h"
#import <Masonry.h>

@interface StoreTableViewCell ()

/** 封面 */
@property (strong,nonatomic) UIImageView *coverImgView;
/** 标题 */
@property (strong,nonatomic) UILabel *titleLabel;
/** 收藏时间 */
@property (strong,nonatomic) UILabel *timeLabel;



@end

@implementation StoreTableViewCell

+ (instancetype)sharedStoreTableCell:(UITableView *)tableView
{
    static NSString *ID = @"StoreTableViewCell";
    StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[StoreTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setNewsModel:(NewsArticleModel *)newsModel
{
    _newsModel = newsModel;
    [_coverImgView sd_setImageWithURL:[NSURL URLWithString:newsModel.news_logo] placeholderImage:[UIImage imageNamed:@"user_place"]];
    _titleLabel.text = newsModel.news_name;
    
    NSString *dateStr = [newsModel.create_time substringWithRange:NSMakeRange(5, 6)];
    _timeLabel.text = dateStr;
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    // 封面
    self.coverImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_place"]];
    [self.contentView addSubview:self.coverImgView];
    [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY).offset(8);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.and.height.equalTo(@60);
    }];
    
    // 标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImgView.mas_right).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(self.coverImgView.mas_centerY);
    }];
    
    // 收藏时间
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.timeLabel.text = @"今天";
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = RGBACOLOR(108, 108, 108, 1);
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.height.equalTo(@18);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    
}

@end
