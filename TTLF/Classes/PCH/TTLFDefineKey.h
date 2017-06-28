
//
//  TTLFDefineKey.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#ifndef TTLFDefineKey_h
#define TTLFDefineKey_h

// RGB
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]
// 蒙蒙的图层
#define CoverColor RGBACOLOR(79, 79, 100, 0.4)
// 随机颜色
#define HWRandomColor RGBACOLOR(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256),1)

// 设备宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// 主色调 FF503C(tabbar红)
#define MainColor RGBACOLOR(253, 179, 20, 1)
// 绿色
#define GreenColor RGBACOLOR(10, 160, 79, 1)
// DisEnbled颜色
#define DisAbledColor RGBACOLOR(108, 80, 77, 1)
// 导航控制器颜色
#define NavColor RGBACOLOR(55, 61, 65, 1)
// 文字颜色
#define TitleColor RGBACOLOR(0, 0, 0, 1)
// 警告的偏红颜色
#define WarningColor RGBACOLOR(242, 73, 78, 1)
// 控制器背景颜色 RGBACOLOR(250, 246, 232, 1)
#define BackColor RGBACOLOR(239, 239, 249, 1)


// 子线程
#define ZCGlobalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
// 主线程
#define ZCMainQueue dispatch_get_main_queue()
//  比例
#define CKproportion [[UIScreen mainScreen] bounds].size.width/375.0f
//  iOS系统版本
#define iOS_Version [[[UIDevice currentDevice] systemVersion] doubleValue]


#ifdef DEBUG // 处于开发阶段
#define KGLog(...) NSLog(__VA_ARGS__)
#else // 处于发布阶段
#define KGLog(...)
#endif

#define LogFuncName KGLog(@"___%s___",__func__);

#endif /* TTLFDefineKey_h */
