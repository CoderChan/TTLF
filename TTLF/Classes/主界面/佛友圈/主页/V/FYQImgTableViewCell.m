//
//  FYQImgTableViewCell.m
//  FYQ
//
//  Created by Chan_Sir on 2017/3/3.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "FYQImgTableViewCell.h"
#import <Masonry.h>


@interface FYQImgTableViewCell ()
/** 头像 */
@property (strong,nonatomic) UIImageView *headIMGView;
/** 昵称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 时间 */
@property (strong,nonatomic) UILabel *timeLabel;
/** 话题 */
@property (strong,nonatomic) UIButton *topicButton;
/** 内容 */
@property (strong,nonatomic) UILabel *contentLabel;
/** 地理位置的按钮 */
@property (strong,nonatomic) UIButton *locationButton;
/** 配置的图片 */
@property (strong,nonatomic) UIImageView *contentIMGV;
/** 底部view */
@property (strong,nonatomic) UIView *bottomView;

@end

@implementation FYQImgTableViewCell

+ (instancetype)sharedFYQImgTableViewCell:(UITableView *)tableView
{
    static NSString *ID = @"FYQImgTableViewCell";
    FYQImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[FYQImgTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    // 头像
    self.headIMGView = [[UIImageView alloc]init];
    self.headIMGView.backgroundColor = [UIColor purpleColor];
    self.headIMGView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.headIMGView];
    [self.headIMGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.width.and.height.equalTo(@(50*CKproportion));
    }];
    
    // 昵称
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
    self.nameLabel.textColor = RGBACOLOR(54, 108, 132, 1);
    self.nameLabel.text = @"我在南山南边";
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headIMGView.mas_right).offset(13);
        make.top.equalTo(self.headIMGView.mas_top);
        make.height.equalTo(@21);
    }];
    
    // 话题
    self.topicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.topicButton setTitle:@"#因果故事#" forState:UIControlStateNormal];
    [self.topicButton setTitleColor:self.nameLabel.textColor forState:UIControlStateNormal];
    [self.topicButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton *sender) {
        [MBProgressHUD showSuccess:sender.titleLabel.text];
    }];
    self.topicButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.topicButton];
    [self.topicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.height.equalTo(@21);
    }];
    
    // 底部视图
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = RGBACOLOR(188, 65, 76, 1);
    [self.contentView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@38);
    }];
    
    // 时间
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.timeLabel.textColor = RGBACOLOR(87, 87, 87, 1);
    self.timeLabel.text = @"15分钟前";
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_top).offset(-5);
        make.left.equalTo(self.nameLabel.mas_left);
        make.height.equalTo(@21);
    }];
    
    // 地理位置
    self.locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.locationButton setTitle:@"北京市·长安大街中南海" forState:UIControlStateNormal];
    self.locationButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.locationButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [MBProgressHUD showError:@"地理位置"];
    }];
    self.locationButton.titleLabel.font = self.timeLabel.font;
    [self.locationButton setTitleColor:self.nameLabel.textColor forState:UIControlStateNormal];
    [self.contentView addSubview:self.locationButton];
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.timeLabel.mas_top);
        make.left.equalTo(self.timeLabel.mas_left);
        make.height.equalTo(@21);
    }];
    
    
    
    // 配图
    self.contentIMGV = [[UIImageView alloc]initWithImage:[UIImage imageWithColor:HWRandomColor]];
    self.contentIMGV.userInteractionEnabled = YES;
    [self.contentView addSubview:self.contentIMGV];
    [self.contentIMGV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.locationButton.mas_top).offset(-5);
        make.left.equalTo(self.nameLabel.mas_left);
        make.width.and.height.equalTo(@80);
    }];
    
    // 内容
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.text = @"孙女士空空荡荡当年的可多可少什么什么上课没快点快点打卡上课你看情况是我看我看我看我看我去看望少年时代看得懂看情况问问可丁可卯我看完快点快点书你看打卡打卡我看看十五年我肯定哇卡哇卡上网看看女士空空荡荡当年的可多可少什么什么上课没快点快点打卡上课你看情况是我看我看我看我看我去看望少年时代看得懂看情况问问可丁可卯我看完快点快点书你看打卡打卡我看看十五年我肯定哇卡哇卡上网看";
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-35);
        make.bottom.equalTo(self.contentIMGV.mas_top).offset(-5);
    }];
    
}

@end
