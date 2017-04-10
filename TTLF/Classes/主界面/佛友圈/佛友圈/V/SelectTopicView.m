//
//  SelectTopicView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SelectTopicView.h"

@interface SelectTopicView ()



@end


#define BottomViewHeight 300
@interface SelectTopicView ()

/** 底部View */
@property (strong,nonatomic) UIView *bottomView;

@end

@implementation SelectTopicView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CoverColor;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [[TTLFManager sharedManager].networkManager getTopicListSuccess:^(NSArray *array) {
        [self setupSubViews:array];
    } Fail:^(NSString *errorMsg) {
        [self setupNoData:errorMsg];
    }];
    
    
}


- (void)setupSubViews:(NSArray *)array
{
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, self.width, BottomViewHeight)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.userInteractionEnabled = YES;
    [self addSubview:self.bottomView];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//        [MBProgressHUD showSuccess:@"莫西莫西"];
//    }];
//    [self.bottomView addGestureRecognizer:tap];
    
    CGFloat spaceH = 30; // 横向间距
    CGFloat spaceZ = 8; // 纵向间距
    CGFloat W = (SCREEN_WIDTH - spaceH*3)/2;  // 宽
    
    // 填充话题
    for (int i = 0; i < array.count; i++) {
        SendTopicModel *topicModel = array[i];
        CGRect frame;
        frame.size.width = W;
        frame.size.height = 40;
        frame.origin.x = (i%2) * (frame.size.width + spaceH) + spaceH;
        frame.origin.y = floor(i/2) * (frame.size.height + spaceZ) + 10;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:topicModel.topic_name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.frame = frame;
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (self.SelectModelBlock) {
                _SelectModelBlock(topicModel);
                [self removeSubViewsFromSuperview:0.2];
            }
        }];
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.cornerRadius = 2;
        button.backgroundColor = [UIColor clearColor];
        [self.bottomView addSubview:button];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.y = self.height - BottomViewHeight;
    } completion:^(BOOL finished) {
        
    }];
    
    // 点击空白处退回
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self removeSubViewsFromSuperview:0.2];
    }];
    button.frame = CGRectMake(0, 0, self.width, self.height - BottomViewHeight);
    [self addSubview:button];
    
}

- (void)setupNoData:(NSString *)errorMsg
{
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, self.width, BottomViewHeight)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.userInteractionEnabled = YES;
    [self addSubview:self.bottomView];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//        [MBProgressHUD showSuccess:@"莫西莫西"];
//    }];
//    [self.bottomView addGestureRecognizer:tap];
    
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"big_nodata"]];
    iconView.frame = CGRectMake(self.bottomView.width/2 - 30, self.bottomView.height/2 - 30 - 10, 60, 60);
    [self.bottomView addSubview:iconView];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconView.frame), self.bottomView.width, 21)];
    tipLabel.text = errorMsg;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.textColor = WarningColor;
    [self.bottomView addSubview:tipLabel];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.y = self.height - BottomViewHeight;
    } completion:^(BOOL finished) {
        
    }];
    
    // 点击空白处退回
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self removeSubViewsFromSuperview:0.2];
    }];
    button.frame = CGRectMake(0, 0, self.width, self.height - BottomViewHeight);
    [self addSubview:button];
}

- (void)removeSubViewsFromSuperview:(CGFloat)seconds
{
    [UIView animateWithDuration:seconds animations:^{
        self.bottomView.y = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
