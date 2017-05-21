//
//  AppDelegate.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/7.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

// 窗口
@property (strong, nonatomic) UIWindow *window;
// QQ
@property (strong,nonatomic) TencentOAuth *tencentOAuth;

@end

