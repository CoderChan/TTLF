//
//  MineTableViewCell.m
//  FYQ
//
//  Created by Chan_Sir on 2017/2/25.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MineTableViewCell.h"
#import <Masonry.h>


@interface MineTableViewCell ()

/** 头像 */
@property (strong,nonatomic) UIImageView *headIMGView;
/** 昵称 */
@property (strong,nonatomic) UILabel *nameLabel;


@end

@implementation MineTableViewCell

+ (instancetype)sharedMineCell:(UITableView *)tableView
{
    static NSString *ID = @"MineTableViewCell";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[MineTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = NavColor;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupSubViews];
    }
    return self;
}

- (void)setUserModel:(UserInfoModel *)userModel
{
    _userModel = userModel;
    if ([userModel.sex intValue] == 1) {
        _nameLabel.text = [NSString stringWithFormat:@"%@♂",userModel.nickName];
    }else{
        _nameLabel.text = [NSString stringWithFormat:@"%@♀",userModel.nickName];
    }
    [_headIMGView sd_setImageWithURL:[NSURL URLWithString:userModel.headUrl] placeholderImage:[UIImage imageNamed:@"user_place"]];
    
}

- (void)setupSubViews
{
    
    // 头像
    self.headIMGView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_place"]];
    self.headIMGView.backgroundColor = [UIColor whiteColor];
    self.headIMGView.layer.masksToBounds = YES;
    self.headIMGView.layer.cornerRadius = 45;
    self.headIMGView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.headIMGView];
    [self.headIMGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY).offset(-15);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.and.height.equalTo(@90);
    }];
    
    // 昵称
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = @"我在终南山下";
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
    self.nameLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headIMGView.mas_bottom).offset(5);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.height.equalTo(@21);
    }];
}

@end
