//
//  SendCommentView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/31.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SendCommentView.h"
#import <Masonry.h>



@interface SendCommentView ()<UITextViewDelegate>

/** 背景视图 */
@property (strong,nonatomic) UIView *bottomView;
/** 输入框 */
@property (strong,nonatomic) UITextView *textView;
/** 小红点 */
@property (strong,nonatomic) UIImageView *redIconView;
/** 发送按钮 */
@property (strong,nonatomic) UIButton *sendButton;
/** 放图片的背景图 */
@property (strong,nonatomic) UIImageView *iconBgView;

@end

@implementation SendCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CoverColor;
        self.userInteractionEnabled = YES;
        
        self.isSendIcon = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    __weak __block SendCommentView *copySelf = self;
    // 添加底部大视图
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, self.width, self.height/2 + 124*CKproportion)];
    self.bottomView.userInteractionEnabled = YES;
    self.bottomView.backgroundColor = BackColor;
    [self addSubview:self.bottomView];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.bottomView.y = self.height/2 - 124*CKproportion;
    } completion:^(BOOL finished) {
        
    }];
    
    // 取消
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancleButton setTitleColor:RGBACOLOR(67, 67, 67, 1) forState:UIControlStateNormal];
    [cancleButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self dismissMyself];
    }];
    cancleButton.frame = CGRectMake(5, 4, 70, 38);
    [self.bottomView addSubview:cancleButton];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bottomView.width/2 - 60, 4, 120, 38)];
    titleLabel.text = @"写跟帖";
    titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottomView addSubview:titleLabel];
    
    // 发送按钮
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.sendButton.enabled = NO;
    [self.sendButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [copySelf sendCommentAction];
    }];
    self.sendButton.frame = CGRectMake(self.width - 5 - 70, 4, 70, 38);
    [self.bottomView addSubview:self.sendButton];
    
    // 输入框
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(cancleButton.frame) + 10, self.width - 20, 110*CKproportion)];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.layer.masksToBounds = YES;
    self.textView.delegate = self;
    self.textView.textColor = RGBACOLOR(35, 35, 35, 1);
    self.textView.layer.cornerRadius = 1;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 0.4f;
    self.textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self.bottomView addSubview:self.textView];
    
    // 添加图标
    UIButton *addImgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addImgButton setImage:[UIImage imageNamed:@"comment_add_icon"] forState:UIControlStateNormal];
    [addImgButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (self.SelectImageBlock) {
            _SelectImageBlock();
        }
    }];
    addImgButton.frame = CGRectMake(10, CGRectGetMaxY(self.textView.frame) + 8, 35, 35);
    [self.bottomView addSubview:addImgButton];
    
    // 小红点
    self.redIconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"comment_red_icon"]];
    self.redIconView.layer.masksToBounds = YES;
    self.redIconView.layer.cornerRadius = 10;
    self.redIconView.backgroundColor = [UIColor whiteColor];
    self.redIconView.frame = CGRectMake(20, -3, 20, 20);
    [addImgButton addSubview:self.redIconView];
    
    // comment_icon_bg@2x
    self.iconBgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"comment_icon_bg"]];
    self.iconBgView.userInteractionEnabled = YES;
    self.iconBgView.frame = CGRectMake(0, CGRectGetMaxY(addImgButton.frame) - 6, self.width, self.bottomView.height - addImgButton.y - addImgButton.height + 6);
    [self.bottomView addSubview:self.iconBgView];
    
    // 评论附带的图片
    self.commentImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fo_bg_09"]];
    self.commentImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.commentImgView.userInteractionEnabled = YES;
    [self.iconBgView addSubview:self.commentImgView];
    [self.commentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconBgView.mas_left).offset(15);
        make.centerY.equalTo(self.iconBgView.mas_centerY);
        make.width.and.height.equalTo(@(130*CKproportion));
    }];
    
    self.redIconView.hidden = YES;
    self.iconBgView.hidden = YES;
    
}

#pragma mark - 发送评论
- (void)sendCommentAction
{
    if ([self.delegate respondsToSelector:@selector(sendCommentWithImage:CommentText:)]) {
        if (self.isSendIcon) {
            // 带图的评论
            [_delegate sendCommentWithImage:self.commentImgView.image CommentText:self.textView.text];
            [self removeFromSuperviewAction];
        }else{
            // 纯文字的评论
            [_delegate sendCommentWithImage:nil CommentText:self.textView.text];
            [self removeFromSuperviewAction];
        }
        
    }
    
}

#pragma mark - 其他方法
- (void)setIsSendIcon:(BOOL)isSendIcon
{
    _isSendIcon = isSendIcon;
    if (isSendIcon) {
        // 发送图
        self.redIconView.hidden = NO;
        self.iconBgView.hidden = NO;
        self.sendButton.enabled = YES;
        [self.sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        // 不发送图
        self.iconBgView.image = nil;
        self.redIconView.hidden = YES;
        self.iconBgView.hidden = YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length >= 3) {
        self.sendButton.enabled = YES;
        [self.sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        self.sendButton.enabled = NO;
        [self.sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (void)dismissMyself
{
    [self endEditing:YES];
    
    for (UIView *subViews in self.bottomView.subviews) {
        [subViews removeFromSuperview];
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
        self.bottomView.y = self.height;
        self.bottomView.x = self.width/2 - 0.5;
        self.bottomView.width = 1;
        self.bottomView.height = 1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

- (void)removeFromSuperviewAction
{
    [self endEditing:YES];
    
    for (UIView *subViews in self.bottomView.subviews) {
        [subViews removeFromSuperview];
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
        self.bottomView.y = -60;
        self.bottomView.x = self.width/2 - 0.5;
        self.bottomView.width = 1;
        self.bottomView.height = 1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)hidHub
{
    [self removeFromSuperviewAction];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}


@end
