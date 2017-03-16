//
//  FYQImgTableViewCell.m
//  FYQ
//
//  Created by Chan_Sir on 2017/3/3.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "FYQImgTableViewCell.h"
#import <SDAutoLayout.h>


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
    
    // 昵称
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.backgroundColor = HWRandomColor;
    self.nameLabel.text = @"我在南山南边";
    [self.contentView addSubview:self.nameLabel];
    
    // 时间
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.timeLabel.backgroundColor = HWRandomColor;
    self.timeLabel.text = @"一天前";
    [self.contentView addSubview:self.timeLabel];
    
    // 话题
    self.topicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.topicButton setTitle:@"#十万个为什么#" forState:UIControlStateNormal];
    [self.topicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.topicButton.backgroundColor = HWRandomColor;
    self.topicButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.topicButton];
    
    // 内容
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.text = @"孙女士空空荡荡当年的可多可少什么什么上课没快点快点打卡上课你看情况是我看我看我看我看我去看望少年时代看得懂看情况问问可丁可卯我看完快点快点书你看打卡打卡我看看十五年我肯定哇卡哇卡上网看看女士空空荡荡当年的可多可少什么什么上课没快点快点打卡上课你看情况是我看我看我看我看我去看望少年时代看得懂看情况问问可丁可卯我看完快点快点书你看打卡打卡我看看十五年我肯定哇卡哇卡上网看";
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.contentLabel];
    
    // 配图
    self.contentIMGV = [[UIImageView alloc]initWithImage:[UIImage imageWithColor:HWRandomColor]];
    self.contentIMGV.userInteractionEnabled = YES;
    [self.contentView addSubview:self.contentIMGV];
    
    // 底部视图
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = RGBACOLOR(188, 65, 76, 1);
    [self.contentView addSubview:self.bottomView];
    
    
    // 头像
    self.headIMGView.sd_layout
    .widthIs(48)
    .heightIs(48)
    .topSpaceToView(self.contentView,10)
    .leftSpaceToView(self.contentView,15);
    
    // 昵称
    self.nameLabel.sd_layout
    .heightIs(30)
    .leftSpaceToView(self.headIMGView,15)
    .rightSpaceToView(self.contentView,150)
    .topEqualToView(self.headIMGView);
    
    // 时间
    self.timeLabel.sd_layout
    .leftEqualToView(self.nameLabel)
    .bottomEqualToView(self.headIMGView)
    .heightIs(18);
    
    // 话题
    self.topicButton.sd_layout
    .rightSpaceToView(self.contentView,15)
    .centerYEqualToView(self.nameLabel)
    .widthIs(130)
    .heightIs(30);
    
    // 文字内容
    self.contentLabel.sd_layout
    .topSpaceToView(self.timeLabel,0)
    .leftEqualToView(self.nameLabel)
    .rightSpaceToView(self.contentView,30)
    .autoHeightRatio(0);
    
    // 底部
    self.bottomView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(40);
    
    // 配图
    self.contentIMGV.sd_layout
    .leftEqualToView(self.contentLabel)
    .bottomSpaceToView(self.bottomView,10)
    .widthIs(80)
    .heightIs(80);
    
    //
    
}

@end
