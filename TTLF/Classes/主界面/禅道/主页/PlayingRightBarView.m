//
//  PlayingRightBarView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/2.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PlayingRightBarView.h"


@interface PlayingRightBarView ()

@property (strong,nonatomic) UIImageView *imageView;

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
