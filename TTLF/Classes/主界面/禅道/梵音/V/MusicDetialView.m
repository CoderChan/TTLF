//
//  MusicDetialView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/6/28.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MusicDetialView.h"

@interface MusicDetialView ()

// 头像
@property (strong,nonatomic) UIImageView *coverImgView;
// 作者昵称
@property (strong,nonatomic) UILabel *writerLabel;
// 梵音名称
@property (strong,nonatomic) UILabel *titleLabel;
// 滚动栏
@property (strong,nonatomic) UITextView *textView;
// 关闭按钮
@property (strong,nonatomic) UIButton *cancleButton;

@end

@implementation MusicDetialView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (SCREEN_WIDTH == 375) {
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cm2_fm_bg_ip6"]];
        }else{
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cm2_fm_bg"]];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    __weak MusicDetialView *copySelf = self;
    
    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancleButton.backgroundColor = MainColor;
    self.cancleButton.frame = CGRectMake(SCREEN_WIDTH/2 - 25, SCREEN_HEIGHT - 66, 50, 50);
    [self.cancleButton setImage:[UIImage imageNamed:@"dismiss"] forState:UIControlStateNormal];
    self.cancleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.cancleButton.layer.cornerRadius = 25;
    [self.cancleButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        // 过度动画
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        CATransition *animation = [CATransition animation];
        animation.duration = 0.6;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionFade;
        animation.subtype = kCATransitionFromBottom;
        [copySelf.window.layer addAnimation:animation forKey:nil];
        [window makeKeyAndVisible];
        [copySelf removeFromSuperview];
    }];
    [self addSubview:self.cancleButton];
    
    // 标题及作者
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 21, self.width - 20, 21)];
    self.titleLabel.text = self.model.music_name;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    self.writerLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.x, CGRectGetMaxY(self.titleLabel.frame), self.titleLabel.width, 20)];
    self.writerLabel.text = self.model.music_author;
    self.writerLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.writerLabel.textColor = [UIColor whiteColor];
    self.writerLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.writerLabel];
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.writerLabel.frame) + 20, SCREEN_WIDTH - 30, SCREEN_HEIGHT - self.cancleButton.height - self.writerLabel.y - self.writerLabel.height - 60)];
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.showsHorizontalScrollIndicator = NO;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.textColor = [UIColor whiteColor];
    self.textView.text = self.model.music_info;
    self.textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.textView.editable = NO;
    [self addSubview:self.textView];
}



@end
