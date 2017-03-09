//
//  SharedView.m
//  FYQ
//
//  Created by Chan_Sir on 2017/1/10.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SharedView.h"
#import "MBProgressHUD+MJ.h"


#define BottomHeight 80
@interface SharedView ()

@end

static SharedView *_mySelf;
@implementation SharedView


- (instancetype)initWithFrame:(CGRect)frame ShareClick:(void (^)(ShareToAPPType))shareBlock
{
    _mySelf = [[SharedView alloc]initWithFrame:frame];
    
    // 底部
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, BottomHeight)];
    bottomView.userInteractionEnabled = YES;
    bottomView.backgroundColor = [UIColor whiteColor];
    [_mySelf addSubview:bottomView];
    [UIView animateWithDuration:0.3 animations:^{
        bottomView.y = frame.size.height - BottomHeight;
    } completion:^(BOOL finished) {
        
    }];
    
    // 蒙版按钮
    UIButton *mengButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mengButton.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - BottomHeight);
    mengButton.backgroundColor = [UIColor blackColor];
    mengButton.alpha = 0.1;
    [mengButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton *sender) {
        [UIView animateWithDuration:0.3 animations:^{
            bottomView.y = frame.size.height;
            sender.alpha = 0;
        } completion:^(BOOL finished) {
            [_mySelf removeFromSuperview];
        }];
    }];
    [_mySelf addSubview:mengButton];
    
    // 微信好友，微信朋友圈，复制链接。
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(ShareAction) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = HWRandomColor;
    [button setTitle:@"微信好友" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, frame.size.width/4, BottomHeight)];
    [bottomView addSubview:button];
    
    return _mySelf;
}

- (void)ShareAction
{
    [MBProgressHUD showError:@"微信好友"];
}

@end
