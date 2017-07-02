//
//  PlayingRightBarView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/2.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PlayingRightBarView.h"


@interface PlayingRightBarView ()
// 音乐图标
@property (strong,nonatomic) UIImageView *imageView;
// 选择动画
@property (strong,nonatomic) CABasicAnimation *xuanzhuanAnimation;

@end

@implementation PlayingRightBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addSubview:self.imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.ClickBlock) {
            _ClickBlock();
        }
    }];
    [self addGestureRecognizer:tap];
    
    self.xuanzhuanAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    self.xuanzhuanAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    self.xuanzhuanAnimation.duration = 8;
    self.xuanzhuanAnimation.speed = 0.5;
    self.xuanzhuanAnimation.cumulative = YES;
    self.xuanzhuanAnimation.repeatCount = 100000;
    [self.imageView.layer addAnimation:self.xuanzhuanAnimation forKey:@"rotationAnimation"];
}
- (void)remoteAnimation
{
    [self.imageView.layer addAnimation:self.xuanzhuanAnimation forKey:@"rotationAnimation"];
}
- (void)stopAnimation
{
    [self.imageView.layer removeAnimationForKey:@"rotationAnimation"];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.image = [UIImage imageNamed:@"music_playing"];
    }
    return _imageView;
}


@end
