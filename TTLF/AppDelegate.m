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
#import <JPUSHService.h>
#import <AVFoundation/AVFoundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "PhoneLoginViewController.h"




@interface AppDelegate ()<JPUSHRegisterDelegate>

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
    
    // 高德地图
    AMapServices *mapManager = [AMapServices sharedServices];
    mapManager.apiKey = GaodeMap_AK;
    
    // MOB短信验证码
    [SMSSDK registerApp:Mob_AppKey withSecret:Mob_Secret];
    
    // QQ
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAppID andDelegate:nil];
    
    // 极光推送
    BOOL isProduction;
#ifdef DEBUG // 处于开发阶段
    isProduction = NO;
#else // 处于发布阶段
    isProduction = YES;
#endif
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:Jpush_AppKey channel:@"AppStore" apsForProduction:isProduction];
    
    
    // 后台播放音乐控制
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
// 注册推送设备标示
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册推送失败 = %@", error);
}
#pragma mark - 极光推送代理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"推送消息 = %@",userInfo);
}
// notification ：前台得到的的通知对象
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    NSLog(@"notification = %@",notification);
}
// response 通知响应对象
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSLog(@"response = %@",response);
}

#pragma mark - APP进入后台/从后台返回
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}



@end
