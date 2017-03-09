//
//  RootNavgationController.m
//  FYQ
//
//  Created by Chan_Sir on 2016/11/24.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "RootNavgationController.h"

@interface RootNavgationController ()

@end

@implementation RootNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

+ (void)initialize
{
    [UINavigationBar appearanceWhenContainedIn:self, nil];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:NavColor];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
        [UIColor whiteColor], NSForegroundColorAttributeName,
        [UIFont boldSystemFontOfSize:18],NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    
    
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    
    // 用图片代替，且不会使自带的返回效果失效
//    UIImage*backButtonImage = [[UIImage imageNamed:@"back"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,30,0,0)];
//    [[UIBarButtonItem appearance]setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin,NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {    // 非根控制器
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
