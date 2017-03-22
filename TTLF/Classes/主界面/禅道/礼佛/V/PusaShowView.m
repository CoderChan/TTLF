//
//  PusaShowView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/21.
//  Copyright © 2017年 陈振超. All rights reserved.
//


#import "PusaShowView.h"


@interface PusaShowView ()

/** 佛像 */
@property (strong,nonatomic) UIImageView *pusaImgView;
/** 滚动视图 */
@property (strong,nonatomic) UIScrollView *scrollView;


@end

@implementation PusaShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

@end
