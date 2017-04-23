//
//  RightMoreView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/21.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "RightMoreView.h"
#import "MoreItemView.h"


@interface RightMoreView ()
{
    UIButton *mengButton;
}

/** 第一行内容数组 */
@property (copy,nonatomic) NSArray *shareArray;
/** 第二行内容数组 */
@property (copy,nonatomic) NSArray *moreArray;
/** 空白处 */
@property (strong,nonatomic) UIView *bottomView;
/** 放置中间按钮的view */
@property (strong,nonatomic) UIView *middleView;


@end

@implementation RightMoreView

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
    
    CGFloat space = 12*CKproportion;
    CGFloat width = (SCREEN_WIDTH - 6*space)/5;
    CGFloat BottomHeight = 30 + 30 + width + 80 + width + 50;
    // 蒙蒙按钮
    mengButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mengButton.frame = CGRectMake(0, 0, self.width, SCREEN_HEIGHT - BottomHeight);
    [mengButton addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mengButton];
    
    
    // 底部白色View
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, self.width, BottomHeight)];
    self.bottomView.userInteractionEnabled = YES;
    self.bottomView.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    [self addSubview:self.bottomView];
    
    // 网页由www.yangruyi.com提供
    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.width, 25)];
    fromLabel.text = @"网页由 www.yangruyi.com 提供";
    fromLabel.textAlignment = NSTextAlignmentCenter;
    fromLabel.textColor = RGBACOLOR(67, 67, 67, 1);
    fromLabel.font = [UIFont systemFontOfSize:14];
    [self.bottomView addSubview:fromLabel];
    
    // 取消
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleButton setTitleColor:RGBACOLOR(25, 25, 25, 1) forState:UIControlStateNormal];
    cancleButton.frame = CGRectMake(0, self.bottomView.height - 50, self.width, 50);
    cancleButton.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    [cancleButton addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.bottomView addSubview:cancleButton];
    
    // 装着按钮的视图
    self.middleView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(fromLabel.frame) + 15, self.width, self.bottomView.height - fromLabel.height - 15 - cancleButton.height - 15)];
    self.middleView.backgroundColor = self.bottomView.backgroundColor;
    [self.bottomView addSubview:self.middleView];
    
    // 创建里面的按钮
    [self addSubViews];
    
    // 出现时的动画
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.y = self.height - BottomHeight;
    }];
    
    
}

#pragma mark - 绘制里面的按钮
- (void)addSubViews
{
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    xian.frame = CGRectMake(0, self.middleView.height/2 - 1, self.middleView.width, 2);
    [self.middleView addSubview:xian];
    
    CGFloat space = 12*CKproportion;
    CGFloat width = (SCREEN_WIDTH - 6*space)/5;
    
    /******** 第一行内容：分享 *********/

    // 发送给朋友
    MoreItemView *wechatFriItem = [[MoreItemView alloc]initWithFrame:CGRectMake(space, (self.middleView.height/2 - width - 38)/2, width, width + 38)];
    wechatFriItem.titleLabel.text = @"发送给朋友";
    wechatFriItem.iconView.image = [UIImage imageNamed:@"share_wechatFri"];
    [self.middleView addSubview:wechatFriItem];
    UITapGestureRecognizer *wechatFriTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if ([self.delegate respondsToSelector:@selector(rightMoreViewWithClickType:)]) {
            [_delegate rightMoreViewWithClickType:WechatFriendType];
            [self removeFromSuperview];
        }
    }];
    [wechatFriItem addGestureRecognizer:wechatFriTap];
    
    // 朋友圈
    MoreItemView *wechatQuanItem = [[MoreItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(wechatFriItem.frame) + space, wechatFriItem.y, width, wechatFriItem.height)];
    wechatQuanItem.iconView.image = [UIImage imageNamed:@"share_quan"];
    wechatQuanItem.titleLabel.text = @"朋友圈";
    [self.middleView addSubview:wechatQuanItem];
    UITapGestureRecognizer *wechatQuanTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if ([self.delegate respondsToSelector:@selector(rightMoreViewWithClickType:)]) {
            [_delegate rightMoreViewWithClickType:WechatQuanType];
            [self removeFromSuperview];
        }
    }];
    [wechatQuanItem addGestureRecognizer:wechatQuanTap];
    
    // 收藏
    MoreItemView *storeItem = [[MoreItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(wechatQuanItem.frame) + space, wechatFriItem.y, width, wechatFriItem.height)];
    storeItem.iconView.image = [UIImage imageNamed:@"share_store"];
    storeItem.titleLabel.text = @"收藏";
    [self.middleView addSubview:storeItem];
    UITapGestureRecognizer *storeTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if ([self.delegate respondsToSelector:@selector(rightMoreViewWithClickType:)]) {
            [_delegate rightMoreViewWithClickType:StoreClickType];
            [self removeFromSuperview];
        }
    }];
    [storeItem addGestureRecognizer:storeTap];
    
    // Safari打开
    MoreItemView *safariItem = [[MoreItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(storeItem.frame) + space, wechatFriItem.y, width, wechatFriItem.height)];
    safariItem.iconView.image = [UIImage imageNamed:@"share_safari"];
    safariItem.titleLabel.text = @"在Safari中\r打开";
    [self.middleView addSubview:safariItem];
    UITapGestureRecognizer *safariTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if ([self.delegate respondsToSelector:@selector(rightMoreViewWithClickType:)]) {
            [_delegate rightMoreViewWithClickType:OpenAtSafariType];
            [self removeFromSuperview];
        }
    }];
    [safariItem addGestureRecognizer:safariTap];
    
    // 系统分享
    MoreItemView *systermItem = [[MoreItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(safariItem.frame) + space, wechatFriItem.y, width, wechatFriItem.height)];
    systermItem.iconView.image = [UIImage imageNamed:@"share_os"];
    systermItem.titleLabel.text = @"系统分享";
    [self.middleView addSubview:systermItem];
    UITapGestureRecognizer *systermTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if ([self.delegate respondsToSelector:@selector(rightMoreViewWithClickType:)]) {
            [_delegate rightMoreViewWithClickType:SystermShareType];
            [self removeFromSuperview];
        }
    }];
    [systermItem addGestureRecognizer:systermTap];
    
    /******** 第二行内容：web相关 *********/
    // 复制链接
    MoreItemView *copyUrlItem = [[MoreItemView alloc]initWithFrame:CGRectMake(space, (self.middleView.height/2 - width - 38)/2 + self.middleView.height/2 + 15, width, width + 38)];
    copyUrlItem.iconView.image = [UIImage imageNamed:@"share_copyUrl"];
    copyUrlItem.titleLabel.text = @"复制链接";
    [self.middleView addSubview:copyUrlItem];
    UITapGestureRecognizer *copyUrlTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if ([self.delegate respondsToSelector:@selector(rightMoreViewWithClickType:)]) {
            [_delegate rightMoreViewWithClickType:CopyUrlType];
            [self removeFromSuperview];
        }
    }];
    [copyUrlItem addGestureRecognizer:copyUrlTap];
    
    // 刷新
    MoreItemView *refreshItem = [[MoreItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(copyUrlItem.frame) + space, copyUrlItem.y, width, copyUrlItem.height)];
    refreshItem.iconView.image = [UIImage imageNamed:@"shared_refresh"];
    refreshItem.titleLabel.text = @"刷新";
    [self.middleView addSubview:refreshItem];
    UITapGestureRecognizer *refreshTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if ([self.delegate respondsToSelector:@selector(rightMoreViewWithClickType:)]) {
            [_delegate rightMoreViewWithClickType:RefreshType];
            [self removeFromSuperview];
        }
    }];
    [refreshItem addGestureRecognizer:refreshTap];
    
    // 停止加载
    MoreItemView *dayNightItem = [[MoreItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(refreshItem.frame) + space, copyUrlItem.y, width, copyUrlItem.height)];
    dayNightItem.iconView.image = [UIImage imageNamed:@"share_stop"];
    dayNightItem.titleLabel.text = @"停止加载";
    [self.middleView addSubview:dayNightItem];
    UITapGestureRecognizer *nightTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if ([self.delegate respondsToSelector:@selector(rightMoreViewWithClickType:)]) {
            [_delegate rightMoreViewWithClickType:StopLoadType];
            [self removeFromSuperview];
        }
    }];
    [dayNightItem addGestureRecognizer:nightTap];
    
}

#pragma mark - 消失
- (void)removeFromSuperview
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.y = self.height;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}


@end
