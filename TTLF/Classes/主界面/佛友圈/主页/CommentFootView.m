//
//  CommentFootView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/30.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "CommentFootView.h"
#import <Masonry.h>


@interface CommentFootView ()

// 评论数
@property (strong,nonatomic) UIButton *discussNumBtn;



@end

@implementation CommentFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = RGBACOLOR(247, 247, 247, 1);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIImageView *xian = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, 2)];
    xian.image = [UIImage imageNamed:@"xian"];
    [self addSubview:xian];
    
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fyq_comment_edit"]];
    [self addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15);
        make.width.equalTo(@20);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"我也说几句···";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = RGBACOLOR(108, 108, 108, 1);
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(2);
        make.centerY.equalTo(iconView.mas_centerY);
        make.height.equalTo(@21);
    }];
    
    
    // 评论数按钮
    self.discussNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.discussNumBtn.frame = CGRectMake(self.width - 80, 0, 70, self.height);
    [self.discussNumBtn setImage:[UIImage imageNamed:@"comment_rightbar"] forState:UIControlStateNormal];
    [self.discussNumBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
    }];
    [self.discussNumBtn setTitle:@"182" forState:UIControlStateNormal];
    self.discussNumBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.discussNumBtn];
    
    UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clickButton.backgroundColor = [UIColor clearColor];
    [clickButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (self.CommentBlock) {
            _CommentBlock();
        }
    }];
    [self addSubview:clickButton];
    [clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.discussNumBtn.mas_left);
    }];
    
}

@end
