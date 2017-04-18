//
//  RootTabbarController.m
//  FYQ
//
//  Created by Chan_Sir on 2016/11/24.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "RootTabbarController.h"
#import "HomeViewController.h"
#import "ZanViewController.h"
#import "DiscoverViewController.h"
#import "WoViewController.h"
#import "TTLFTabbar.h"
#import "SendDynViewController.h"
#import "RootNavgationController.h"

@interface RootTabbarController ()<TTLFTabbarDelegate,UITabBarControllerDelegate>


@end

@implementation RootTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self setupOptions];
    [self addChildControllers];
    
}
#pragma mark - 初始化设置
- (void)setupOptions
{
    
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tabBar setTranslucent:NO];
    [self.tabBar setBarTintColor:NavColor];
}
- (void)addChildControllers
{
    
    HomeViewController *vc1 = [[HomeViewController alloc] init];
    [self addChildVC:vc1 Title:@"佛友圈" image:@"tree_normal" selectedImage:@"tree_normal" Tag:1];
    
    ZanViewController *vc2 = [[ZanViewController alloc] init];
    [self addChildVC:vc2 Title:@"禅道" image:@"tree_normal" selectedImage:@"tree_normal" Tag:2];
    
    DiscoverViewController *vc3 = [[DiscoverViewController alloc] init];
    vc3.tabBarItem.badgeValue = @"12";
    [self addChildVC:vc3 Title:@"发现" image:@"tree_normal" selectedImage:@"tree_normal" Tag:3];
    
    WoViewController *vc4 = [[WoViewController alloc]init];
    [self addChildVC:vc4 Title:@"修行者" image:@"tree_normal" selectedImage:@"tree_normal" Tag:4];
    
    TTLFTabbar *cusTabbar = [[TTLFTabbar alloc]init];
    cusTabbar.sendDelegate = self;
    [self setValue:cusTabbar forKeyPath:@"tabBar"];
    
    // 设置一些被控制的控制器
    [TTLFManager sharedManager].homeVC = vc1;
    [TTLFManager sharedManager].tabbar = self;
    
}
#pragma mark - 添加子控制器
- (void)addChildVC:(UIViewController *)childVC Title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage Tag:(NSInteger)tag
{
    childVC.title = title;
    childVC.tabBarItem.tag = tag;
    
    // 普通图标
    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    // 高亮图标
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *textAttres = [NSMutableDictionary dictionary];
    textAttres[NSFontAttributeName] = [UIFont systemFontOfSize:9];
    textAttres[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    
    NSMutableDictionary *selectTextAttres = [NSMutableDictionary dictionary];
    selectTextAttres[NSForegroundColorAttributeName] = [UIColor whiteColor];
    selectTextAttres[NSFontAttributeName] = [UIFont systemFontOfSize:9];
    
    [childVC.tabBarItem setTitleTextAttributes:textAttres forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:selectTextAttres forState:UIControlStateSelected];
    RootNavgationController *normalNav = [[RootNavgationController alloc]initWithRootViewController:childVC];
    [self addChildViewController:normalNav];
    
}

#pragma mark - 点击中间tabbar
- (void)tabbarDidClickSendBtn:(TTLFTabbar *)tabbar
{
    SendDynViewController *send = [SendDynViewController new];
    RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:send];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark - 设置tabbar只支持竖屏
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    NSLog(@"W = %g,H = %g",size.width,size.height);
}
#pragma mark - 双击事件处理
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    if (tabBarController.selectedIndex != 0) {
        return YES;
    }else{
        //双击处理
        if ([self checkIsDoubleClick:[tabBarController.viewControllers firstObject]]) {
            // 告诉第一个界面双击了，刷新界面
            [[TTLFManager sharedManager].homeVC douleClickReloadAction];
        }
        return YES;
    }
}

- (BOOL)checkIsDoubleClick:(UIViewController *)viewController
{
    static UIViewController *lastViewController = nil;
    static NSTimeInterval lastClickTime = 0;
    
    if (lastViewController != viewController) {
        lastViewController = viewController;
        lastClickTime = [NSDate timeIntervalSinceReferenceDate];
        
        return NO;
    }
    
    NSTimeInterval clickTime = [NSDate timeIntervalSinceReferenceDate];
    if (clickTime - lastClickTime > 0.5 ) {
        lastClickTime = clickTime;
        return NO;
    }
    
    lastClickTime = clickTime;
    return YES;
}

@end
