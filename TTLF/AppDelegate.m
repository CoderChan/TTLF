//
//  AppDelegate.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/7.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AppDelegate.h"
#import "LiFoViewController.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import "RootTabbarController.h"
#import "RootNavgationController.h"
#import "WechatLoginViewController.h"
#import "RootTabbarController.h"
#import <SMS_SDK/SMSSDK.h>
#import "PhoneLoginViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = NavColor;
    [self setupSDKWithOptions:launchOptions];
    [self chooseRootViewControllerWithVersion];
    [self.window makeKeyAndVisible];
    
    return YES;
}

/** 初始化主界面 */
- (void)chooseRootViewControllerWithVersion
{
    UserInfoModel *model = [[TTLFManager sharedManager].userManager getUserInfo];
    if ([AccountTool account] && model.userID) {
        
        // 礼佛界面
//        LiFoViewController *lifoVC = [[LiFoViewController alloc] init];
//        RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:lifoVC];
//        [TTLFManager sharedManager].lifoVC = lifoVC;
//        self.window.rootViewController = nav;
        
        // tabbar
        RootTabbarController *tabbar = [[RootTabbarController alloc] init];
        self.window.rootViewController = tabbar;
        
        
    }else{
        if ([WXApi isWXAppInstalled]) {
            WechatLoginViewController *wechatLogin = [WechatLoginViewController new];
            RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:wechatLogin];
            self.window.rootViewController = nav;
        }else{
            PhoneLoginViewController *wechatLogin = [PhoneLoginViewController new];
            RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:wechatLogin];
            self.window.rootViewController = nav;
        }
    }
}

#pragma mark - 初始化各个第三方库
- (void)setupSDKWithOptions:(NSDictionary *)launchOptions
{
    // 微信SDK
    [WXApi registerApp:WeChatAppID enableMTA:YES];
    
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
    [WXApi registerAppSupportContentFlag:typeFlag];
    
    // 百度地图
    BMKMapManager *mapManager = [[BMKMapManager alloc]init];
    [mapManager start:BaiduMap_AK generalDelegate:nil];
    
    // MOB短信验证码
    [SMSSDK registerApp:Mob_AppKey withSecret:Mob_Secret];
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
#pragma mark - 程序即将进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[TTLFManager sharedManager].lifoVC beginLightingAction];
}





@end
