//
//  GoodClassHeadView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "GoodClassHeadView.h"
#import <Masonry.h>

@interface GoodClassHeadView ()

/** 宣传图 */
@property (strong,nonatomic) UIImageView *adImgView;
/** 宣传文字 */
@property (strong,nonatomic) UILabel *adLabel;
/** 该系列主推产品昵称 */
@property (strong,nonatomic) UILabel *mainGoodLabel;

@end

@implementation GoodClassHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    
    // 广告宣传图
    self.adImgView = [[UIImageView alloc]init];
    [self.adImgView sd_setImageWithURL:[NSURL URLWithString:@"http://s10.sinaimg.cn/large/001xMGI3gy6Mbtd7la179"] placeholderImage:[UIImage imageWithColor:HWRandomColor]];
    [self addSubview:self.adImgView];
    [self.adImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
    // 主标语
    self.adLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, self.width - 30, 24)];
    self.adLabel.text = @"精选小叶紫檀";
    self.adLabel.font = [UIFont boldSystemFontOfSize:22];
    self.adLabel.textColor = [UIColor whiteColor];
    [self.adImgView addSubview:self.adLabel];
    
    // 改系列主推产品
    self.mainGoodLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.mainGoodLabel.text = @"1.5厘米小叶紫檀";
    self.mainGoodLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.mainGoodLabel.textColor = [UIColor whiteColor];
    [self.adImgView addSubview:self.mainGoodLabel];
    [self.mainGoodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.adLabel.mas_left);
        make.top.equalTo(self.adLabel.mas_bottom);
        make.height.equalTo(@21);
    }];
    
    // 底部白色栏
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectZero];
    bottomView.backgroundColor = BackColor;
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.adImgView.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    
}

@end
