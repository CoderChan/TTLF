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
@property (strong,nonatomic) UILabel *discussNumLabel;



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
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(self.width - 60, xian.height, 60, self.height - xian.height);
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (self.CommentBlock) {
            _CommentBlock(PushToCommentControlerType);
        }
    }];
    [self addSubview:rightButton];
    
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
    
    
    UIImageView *discussImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"comment_rightbar"]];
    discussImgView.contentMode = UIViewContentModeScaleAspectFill;
    [rightButton addSubview:discussImgView];
    [discussImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightButton.mas_left).offset(5);
        make.centerY.equalTo(rightButton.mas_centerY);
        make.width.and.height.equalTo(@30);
    }];
    
    // 评论数
    self.discussNumLabel = [[UILabel alloc]init];
    self.discussNumLabel.text = @"12";
    self.discussNumLabel.textColor = MainColor;
    [self.discussNumLabel sizeToFit];
    self.discussNumLabel.backgroundColor = self.backgroundColor;
    self.discussNumLabel.font = [UIFont boldSystemFontOfSize:10];
    [discussImgView addSubview:self.discussNumLabel];
    [self.discussNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(discussImgView.mas_right).offset(-8);
        make.top.equalTo(discussImgView.mas_top);
        make.height.equalTo(@12);
    }];
    
    // 立刻评论
    UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clickButton.backgroundColor = [UIColor clearColor];
    [clickButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (self.CommentBlock) {
            _CommentBlock(PresentCommentViewType);
        }
    }];
    [self addSubview:clickButton];
    [clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(rightButton.mas_left);
    }];
    
}

@end
