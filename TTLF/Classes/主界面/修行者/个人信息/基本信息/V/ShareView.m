//
//  ShareView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/6/24.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "ShareView.h"
#import "UIButton+Category.h"

@interface ShareView ()
{
    UIButton *mengButton;
}

/** 空白处 */
@property (strong,nonatomic) UIView *bottomView;

@end

@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CoverColor;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat space = 1;
    CGFloat width = (SCREEN_WIDTH - 5*space)/4;
    CGFloat BottomHeight = width + width + 50 + space * 3;
    // 蒙蒙按钮
    mengButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mengButton.frame = CGRectMake(0, 0, self.width, SCREEN_HEIGHT - BottomHeight);
    [mengButton addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mengButton];
    
    
    // 底部白色View
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, self.width, BottomHeight)];
    self.bottomView.userInteractionEnabled = YES;
//    self.bottomView.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bottomView];
    
    
    // 取消
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleButton setTitleColor:RGBACOLOR(25, 25, 25, 1) forState:UIControlStateNormal];
    cancleButton.frame = CGRectMake(0, self.bottomView.height - 50, self.width, 50);
    cancleButton.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    [cancleButton addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.bottomView addSubview:cancleButton];
    
    
    // 出现时的动画
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.y = self.height - BottomHeight;
    }];
    
    // 添加分享item
    [self addSubViewsActionWithSpace:space Width:width];
}

- (void)addSubViewsActionWithSpace:(CGFloat)space Width:(CGFloat)width
{
    NSArray *titleArray = @[@"发送给好友",@"朋友圈",@"QQ好友",@"QQ空间",@"微  博",@"系统分享",@"微信收藏"];
    NSArray *iconArray = @[@"share_wechatFri",@"share_quan",@"share_friend",@"share_space",@"share_sina",@"share_os",@"share_store"];
    
    for (int i = 0; i < titleArray.count; i++) {
        CGRect frame;
        frame.origin.x = (i%4) * (frame.size.width + space) + space;
        frame.origin.y = floor(i/4) * (frame.size.height + space);
        frame.size.width = width;
        frame.size.height = width;
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:iconArray[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:iconArray[i]] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i + 1;
        [button addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.textColor = RGBACOLOR(65, 65, 65, 1);
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.backgroundColor = [UIColor whiteColor];
        [self.bottomView addSubview:button];
        
        [button centerImageAndTitle:5];
    }
}

#pragma mark - 消失
- (void)removeFromSuperview
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.y = self.height;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}


- (void)shareClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(shareViewClickWithType:)]) {
        [_delegate shareViewClickWithType:sender.tag];
        [self removeFromSuperview];
    }
}

@end
