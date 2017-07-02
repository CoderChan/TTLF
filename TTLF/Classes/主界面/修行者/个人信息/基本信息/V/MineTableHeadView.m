//
//  MineTableHeadView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/20.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MineTableHeadView.h"
#import <Masonry.h>


@interface MineTableHeadView ()

/** 头像 */
@property (strong,nonatomic) UIImageView *headIMGView;
/** 昵称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 身份用户身份信息 */
@property (strong,nonatomic) UILabel *typeLabel;

@end

@implementation MineTableHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = NavColor;
        self.userInteractionEnabled = YES;
        [self setupSubViews];
    }
    return self;
}

- (void)setUserModel:(UserInfoModel *)userModel
{
    _userModel = userModel;
    _nameLabel.text = userModel.nickName;
    [_headIMGView sd_setImageWithURL:[NSURL URLWithString:userModel.headUrl] placeholderImage:[UIImage imageNamed:@"user_place"]];
    if (userModel.type == 6) {
        _nameLabel.textColor = MainColor;
        _typeLabel.textColor = RGBACOLOR(253, 199, 40, 1);
        _typeLabel.text = @"超级管理员";
    }else if (userModel.type == 7){
        _nameLabel.textColor = MainColor;
        _typeLabel.textColor = RGBACOLOR(253, 199, 40, 1);;
        _typeLabel.text = @"普通管理员";
    }else if (userModel.type == 8){
        //        _typeLabel.text = @"普通用户";
        [_typeLabel removeFromSuperview];
    }else{
//        _typeLabel.text = [NSString stringWithFormat:@"type=%d",userModel.type];
        [_typeLabel removeFromSuperview];
    }
}

- (void)setupSubViews
{
    // 头像
    self.headIMGView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_place"]];
    self.headIMGView.backgroundColor = [UIColor clearColor];
    self.headIMGView.layer.masksToBounds = YES;
    self.headIMGView.contentMode = UIViewContentModeScaleAspectFill;
    [self.headIMGView setContentScaleFactor:[UIScreen mainScreen].scale];
    self.headIMGView.layer.masksToBounds = YES;
    self.headIMGView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.headIMGView.layer.cornerRadius = 45*CKproportion;
    [self addSubview:self.headIMGView];
    [self.headIMGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(-15);
        make.centerX.equalTo(self.mas_centerX);
        make.width.and.height.equalTo(@(90*CKproportion));
    }];
    
    // 昵称
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = @"我在终南山下";
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
    self.nameLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headIMGView.mas_bottom).offset(5);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@21);
    }];
    
    // 身份信息
    self.typeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.typeLabel.text = @"普通用户";
    self.typeLabel.font = [UIFont systemFontOfSize:14];
    self.typeLabel.textColor = [UIColor whiteColor];
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(1);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@21);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.ClickBlock) {
            _ClickBlock();
        }
    }];
    [self addGestureRecognizer:tap];
    
}

@end
