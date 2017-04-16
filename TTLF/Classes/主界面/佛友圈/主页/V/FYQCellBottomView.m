//
//  FYQCellBottomView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/14.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "FYQCellBottomView.h"
#import <Masonry.h>

@interface FYQCellBottomView ()

/** 转发 */
@property (strong,nonatomic) UIButton *reshareButton;
/** 评论 */
@property (strong,nonatomic) UIButton *commentButton;
/** 点赞 */
@property (strong,nonatomic) UIButton *zanButton;

@end

@implementation FYQCellBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    __weak __block FYQCellBottomView *copySelf = self;
    
//    UIImageView *topXian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
//    [self addSubview:topXian];
//    [topXian mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(15);
//        make.right.equalTo(self.mas_right).offset(-15);
//        make.top.equalTo(self.mas_top);
//        make.height.equalTo(@2);
//    }];
    
    UIImageView *bottomXian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    [self addSubview:bottomXian];
    [bottomXian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@2);
    }];
    
    // 分享
    self.reshareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.reshareButton setImage:[UIImage imageNamed:@"fyq_share_normal"] forState:UIControlStateNormal];
    [self.reshareButton setTitle:@"23" forState:UIControlStateNormal];
    [self.reshareButton setTitleColor:RGBACOLOR(48, 48, 48, 1) forState:UIControlStateNormal];
    [self.reshareButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (copySelf.ClickBlock) {
            copySelf.ClickBlock(ShareType);
        }
    }];
    self.reshareButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.reshareButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.reshareButton];
    [self.reshareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(bottomXian.mas_top);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(@(SCREEN_WIDTH/3));
    }];
    
    // 评论
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentButton setImage:[UIImage imageNamed:@"fyq_comment_normal"] forState:UIControlStateNormal];
    [self.commentButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (copySelf.ClickBlock) {
            copySelf.ClickBlock(CommentType);
        }
    }];
    [self.commentButton setTitle:@"23" forState:UIControlStateNormal];
    [self.commentButton setTitleColor:RGBACOLOR(48, 48, 48, 1) forState:UIControlStateNormal];
    self.commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.commentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.commentButton];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(bottomXian.mas_top);
        make.left.equalTo(self.reshareButton.mas_right);
        make.width.equalTo(@(SCREEN_WIDTH/3));
    }];
    
    // 点赞
    self.zanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zanButton setImage:[UIImage imageNamed:@"fyq_zan_normal"] forState:UIControlStateNormal];
    [self.zanButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (copySelf.ClickBlock) {
            copySelf.ClickBlock(ZanType);
        }
    }];
    [self.zanButton setTitle:@"23" forState:UIControlStateNormal];
    [self.zanButton setTitleColor:RGBACOLOR(48, 48, 48, 1) forState:UIControlStateNormal];
    self.zanButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.zanButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.zanButton];
    [self.zanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(bottomXian.mas_top);
        make.left.equalTo(self.commentButton.mas_right);
        make.width.equalTo(@(SCREEN_WIDTH/3));
    }];
    
}



@end
