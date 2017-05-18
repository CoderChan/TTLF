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
/** 宣传附带文字 */
@property (strong,nonatomic) UILabel *detialLabel;

@end

@implementation GoodClassHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.adImgView = [[UIImageView alloc]init];
    [self.adImgView sd_setImageWithURL:[NSURL URLWithString:@"http://s10.sinaimg.cn/large/001xMGI3gy6Mbtd7la179"] placeholderImage:[UIImage imageWithColor:HWRandomColor]];
    [self addSubview:self.adImgView];
    [self.adImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
    }];
    
    self.adLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, self.width - 30, 24)];
    self.adLabel.text = @"精选小叶紫檀";
    self.adLabel.font = [UIFont boldSystemFontOfSize:20];
    self.adLabel.textColor = [UIColor whiteColor];
    [self.adImgView addSubview:self.adLabel];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectZero];
    bottomView.backgroundColor = BackColor;
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@15);
    }];
    
    
}

@end
