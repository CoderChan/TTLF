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

@interface RootTabbarController ()<TTLFTabbarDelegate>

@end

@implementation RootTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupOptions];
    [self addChildControllers];
    
}
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
    [self addChildVC:vc1 Title:@"佛友圈" image:@"tree_normal" selectedImage:@"tree_highted" Tag:1];
    
    ZanViewController *vc2 = [[ZanViewController alloc] init];
    [self addChildVC:vc2 Title:@"禅道" image:@"tree_normal" selectedImage:@"tree_highted" Tag:2];
    
    DiscoverViewController *vc3 = [[DiscoverViewController alloc] init];
    vc3.tabBarItem.badgeValue = @"12";
    [self addChildVC:vc3 Title:@"发现" image:@"tree_normal" selectedImage:@"tree_highted" Tag:3];
    
    WoViewController *vc4 = [[WoViewController alloc]init];
    [self addChildVC:vc4 Title:@"修行者" image:@"tree_normal" selectedImage:@"tree_highted" Tag:4];
    
    TTLFTabbar *cusTabbar = [[TTLFTabbar alloc]init];
    cusTabbar.sendDelegate = self;
    [self setValue:cusTabbar forKeyPath:@"tabBar"];
}
#pragma mark - 添加子控制器
- (void)addChildVC:(UIViewController *)childVC Title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage Tag:(NSInteger)tag
{
    childVC.title = title;
    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.tag = tag;
    
    //    childVC.tabBarItem.imag
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *textAttres = [NSMutableDictionary dictionary];
    textAttres[NSFontAttributeName] = [UIFont systemFontOfSize:9];
    textAttres[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    NSMutableDictionary *selectTextAttres = [NSMutableDictionary dictionary];
    selectTextAttres[NSForegroundColorAttributeName] = MainColor;
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

@end
