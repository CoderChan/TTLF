//
//  PayOrderView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/26.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PayOrderView.h"



@interface PayOrderView ()
{
    UIButton *mengButton;
}
/** 空白处 */
@property (strong,nonatomic) UIView *bottomView;

@end

@implementation PayOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CoverColor;
        self.userInteractionEnabled = YES;
//        self.layer.shadowOpacity = 0.8;
//        self.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.layer.shadowRadius = 5;
//        self.layer.shadowOffset = CGSizeMake(5, 5);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat BottomHeight = 300;
    // 蒙蒙按钮
    mengButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mengButton.frame = CGRectMake(0, 0, self.width, SCREEN_HEIGHT - BottomHeight);
    [mengButton addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mengButton];
    
    // 空白处
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, self.width, BottomHeight)];
    self.bottomView.userInteractionEnabled = YES;
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bottomView];
    
    
    // 出现时的动画
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.y = self.height - BottomHeight;
    }];

}

- (void)removeFromSuperview
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.y = self.height;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

@end
