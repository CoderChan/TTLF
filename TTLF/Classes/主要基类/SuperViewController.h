//
//  SuperViewController.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface SuperViewController : UIViewController

/** 网络数据为空或其他异常时，把message显示在视图上 */
- (void)showEmptyViewWithMessage:(NSString *)message;
/** 隐藏message */
- (void)hideMessageAction;
/** 发送消息到QQ */
- (void)sendToQQWithSendResult:(QQApiSendResultCode)sendResult;
/** 显示POP提示 */
- (void)showPopTipsWithMessage:(NSString *)message AtView:(UIView *)atView inView:(UIView *)inView;

@end
