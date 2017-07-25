//
//  AllUserTableViewCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/7/4.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AllUserTableViewCell.h"
#import <Masonry.h>


@interface AllUserTableViewCell ()

/** 图标 */
@property (strong,nonatomic) UIImageView *iconView;
/** 标题 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 注册时间 */
@property (strong,nonatomic) UILabel *timeLabel;
/** 功德值 */
@property (strong,nonatomic) UILabel *punnaLabel;

@end

@implementation AllUserTableViewCell

+ (instancetype)sharedCell:(UITableView *)tableView
{
    static NSString *ID = @"AllUserTableViewCell";
    AllUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[AllUserTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(AllUserModel *)model
{
    _model = model;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.headurl] placeholderImage:[UIImage imageNamed:@"user_place"]];
    _nameLabel.text = model.nickname;
    _timeLabel.text = model.register_time;
    _punnaLabel.text = model.punnanum;
}

- (void)setupSubViews
{
    self.iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_place"]];
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    [self.iconView setContentScaleFactor:[UIScreen mainScreen].scale];
    self.iconView.layer.masksToBounds = YES;
    self.iconView.autoresizingMask = UIViewAutoresizingFlexibleHeight & UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.and.height.equalTo(@48);
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.textColor = TitleColor;
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconView.mas_centerY).offset(-10);
        make.left.equalTo(self.iconView.mas_right).offset(12);
        make.height.equalTo(@23);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.height.equalTo(@21);
    }];
    
    self.punnaLabel = [[UILabel alloc]init];
    self.punnaLabel.textColor = MainColor;
    self.punnaLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.punnaLabel];
    [self.punnaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-1);
        make.height.equalTo(@21);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}



@end
