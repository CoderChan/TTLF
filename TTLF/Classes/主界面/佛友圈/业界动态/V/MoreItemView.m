//
//  MoreItemView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/21.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MoreItemView.h"
#import <Masonry.h>


@implementation MoreItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        [self layoutSubviewsAction];
    }
    return self;
}

- (void)layoutSubviewsAction
{
//    [super layoutSubviews];
    
    
    UIView *emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.width)];
    emptyView.backgroundColor = RGBACOLOR(250, 249, 249, 1);
    emptyView.layer.masksToBounds = YES;
    emptyView.layer.cornerRadius = 6;
    [self addSubview:emptyView];
    
    // 图标
    self.iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"share_pengyouquan"]];
    [emptyView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(emptyView.mas_centerX);
        make.centerY.equalTo(emptyView.mas_centerY);
        make.width.and.height.equalTo(@35);
    }];
    
    // 标题
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.text = @"发送给朋友";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    self.titleLabel.textColor = RGBACOLOR(39, 39, 39, 1);
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(emptyView.mas_bottom).offset(7);
        make.right.equalTo(self.mas_right);
    }];
}

@end
