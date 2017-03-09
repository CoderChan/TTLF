//
//  UIViewController+Category.h
//  FYQ
//
//  Created by Chan_Sir on 2016/12/12.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Category)

- (void)sendAlertAction:(NSString *)message;

#pragma mark -  将字典或数组转化为JSON串
- (NSString *)toJsonStr:(id)object;


@end
