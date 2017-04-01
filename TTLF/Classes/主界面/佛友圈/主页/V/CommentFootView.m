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

// 点赞按钮
@property (strong,nonatomic) UIButton *zanButton;
//


@end

@implementation CommentFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
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
    
    self.zanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zanButton setImage:[UIImage imageNamed:@"comment_zan_normal"] forState:UIControlStateNormal];
    [self.zanButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton *sender) {
        [sender setImage:[UIImage imageNamed:@"comment_zan_highted"] forState:UIControlStateNormal];
    }];
    [self addSubview:self.zanButton];
    [self.zanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-8);
        make.width.and.height.equalTo(@38);
    }];
    
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
        make.right.equalTo(self.zanButton.mas_left).offset(-8);
    }];
    
}

@end
