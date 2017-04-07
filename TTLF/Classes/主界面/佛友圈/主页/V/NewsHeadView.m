//
//  NewsHeadView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/4.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "NewsHeadView.h"
#import <Masonry.h>


@interface NewsHeadView ()

@property (strong,nonatomic) UIImageView *headImgView;

@property (strong,nonatomic) UILabel *nameLabel;

@property (strong,nonatomic) UILabel *gongdeLabel;

@end


@implementation NewsHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self layoutSubviewsssss];
    }
    return self;
}

- (void)setUserModel:(UserInfoModel *)userModel
{
    _userModel = userModel;
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:userModel.headUrl] placeholderImage:[UIImage imageNamed:@"user_place"]];
    _nameLabel.text = userModel.nickName;
    
    NSString *tempStr = [NSString stringWithFormat:@"功德值 %@",self.userModel.punnaNum];
    NSRange range = [tempStr rangeOfString:self.userModel.punnaNum];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:tempStr];
    [attributeStr beginEditing];
    [attributeStr addAttributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote],NSForegroundColorAttributeName:[UIColor whiteColor]} range:range];
    _gongdeLabel.attributedText = attributeStr;
}

- (void)layoutSubviewsssss
{
//    [super layoutSubviews];
    
    // 240
    // 1、个人信息的底部视图
    UIView *userView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height * 0.35)];
    userView.userInteractionEnabled = YES;
    userView.backgroundColor = NavColor;
    [self addSubview:userView];
    
    // 我的头像
    self.headImgView = [[UIImageView alloc]init];
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.userModel.headUrl] placeholderImage:[UIImage imageNamed:@"user_place"]];
    self.headImgView.userInteractionEnabled = YES;
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = 20;
    [userView addSubview:self.headImgView];
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userView.mas_top).offset(12);
        make.left.equalTo(userView.mas_left).offset(15);
        make.width.and.height.equalTo(@40);
    }];
    
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.ClickBlock) {
            _ClickBlock(UserClickType);
        }
    }];
    [self.headImgView addGestureRecognizer:headTap];
    
    // 我的名称
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = self.userModel.nickName;
    self.nameLabel.userInteractionEnabled = YES;
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
    [userView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headImgView.mas_centerY);
        make.left.equalTo(self.headImgView.mas_right).offset(12);
        make.height.equalTo(@24);
    }];
    
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.ClickBlock) {
            _ClickBlock(UserClickType);
        }
    }];
    [self.nameLabel addGestureRecognizer:nameTap];
    
    // 右边功德值
    UIView *gongdeView = [[UIView alloc]initWithFrame:CGRectZero];
    gongdeView.userInteractionEnabled = YES;
    gongdeView.backgroundColor = RGBACOLOR(50, 107, 80, 1);
    gongdeView.layer.masksToBounds = YES;
    gongdeView.layer.cornerRadius = 23;
    gongdeView.layer.shadowColor = [UIColor purpleColor].CGColor;
    gongdeView.layer.shadowOpacity = 0.8f;
    gongdeView.layer.shadowRadius = 4.f;
    gongdeView.layer.shadowOffset = CGSizeMake(2, 2);
    [userView addSubview:gongdeView];
    [gongdeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(userView.mas_right);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.headImgView.mas_centerY);
        make.height.equalTo(@46);
    }];
    
    UITapGestureRecognizer *gongdeTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.ClickBlock) {
            _ClickBlock(GongdeClickType);
        }
    }];
    [gongdeView addGestureRecognizer:gongdeTap];
    
    // 功德值
    self.gongdeLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 8, 100 - 2, 30)];
    self.gongdeLabel.textAlignment = NSTextAlignmentCenter;
    self.gongdeLabel.text = [NSString stringWithFormat:@"功德值 %@",self.userModel.punnaNum];
    self.gongdeLabel.textColor = [UIColor whiteColor];
    self.gongdeLabel.font = [UIFont systemFontOfSize:10];
    [gongdeView addSubview:self.gongdeLabel];
    
    
    // 2、新闻节目
    UIView *newsView = [[UIView alloc]initWithFrame:CGRectMake(20, self.height * 0.27, self.width - 40, self.height * 0.73 - 15)];
    newsView.backgroundColor = [UIColor whiteColor];
    newsView.userInteractionEnabled = YES;
    newsView.layer.shadowColor = [UIColor blackColor].CGColor;
    newsView.layer.shadowOpacity = 0.8f;
    newsView.layer.shadowRadius = 4.f;
    newsView.layer.shadowOffset = CGSizeMake(0, 0);
    [self addSubview:newsView];
    
    UITapGestureRecognizer *newsTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.ClickBlock) {
            _ClickBlock(NewsClickType);
        }
    }];
    [newsView addGestureRecognizer:newsTap];
    
    // 线
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    [self addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
    }];
    
    
    
}



@end
