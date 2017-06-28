//
//  UIViewController+Category.h
//  FYQ
//
//  Created by Chan_Sir on 2016/12/12.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Category)

/** AlertView提示 */
- (void)sendAlertAction:(NSString *)message;
/** 单个AlertView带回调的提示 */
- (void)showOneAlertWithMessage:(NSString *)message ConfirmClick:(void (^)())clickBlock;
/** 双AlertView带回调的提示 */
- (void)showTwoAlertWithMessage:(NSString *)message ConfirmClick:(void (^)())clickBlock;

/** 判断当前网络为蜂窝网络还是WiFi */
- (void)networkingType:(void (^)(AFNetworkReachabilityStatus status))netType;

/** 将字典或数组转化为JSON串 */
- (NSString *)toJsonStr:(id)object;

/** 闪烁灯动画效果 */
- (CABasicAnimation *)AlphaLight:(float)time;

/** 数组随机排序 */
- (NSArray *)randomizedArrayWithArray:(NSArray *)array;

/** 前往权限设置 */
- (void)openSettingWithTips:(NSString *)tips;


/**
 加文字水印

 @param img 传入的图片
 @param name 水印文字
 @return 加完水印后的图片
 */
- (UIImage *)addWaterImage:(UIImage *)img Name:(NSString *)name;


@end
