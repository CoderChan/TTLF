//
//  NewsHeadView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/4.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "NewsHeadView.h"


@interface NewsHeadView ()

@property (strong,nonatomic) UIImageView *headImgView;

@property (strong,nonatomic) UILabel *nameLabel;

@end


@implementation NewsHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = HWRandomColor;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 我的头像
//    self.headImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.userModel.headUrl]];
}



@end
