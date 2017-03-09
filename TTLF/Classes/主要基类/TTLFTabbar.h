//
//  TTLFTabbar.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TTLFTabbar;

@protocol TTLFTabbarDelegate <UITabBarDelegate>

- (void)tabbarDidClickSendBtn:(TTLFTabbar *)tabbar;

@end

@interface TTLFTabbar : UITabBar

@property (weak,nonatomic) id<TTLFTabbarDelegate> sendDelegate;

@end
