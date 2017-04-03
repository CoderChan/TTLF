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

/** 将字典或数组转化为JSON串 */
- (NSString *)toJsonStr:(id)object;

/** 闪烁灯动画效果 */
- (CABasicAnimation *)AlphaLight:(float)time;

/** 数组随机排序 */
- (NSArray *)randomizedArrayWithArray:(NSArray *)array;


@end
