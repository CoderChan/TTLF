//
//  WechatLoginViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/2/24.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "WechatLoginViewController.h"
#import "PhoneLoginViewController.h"
#import <Masonry.h>
#import "RootTabbarController.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import "RootNavgationController.h"
#import "LiFoViewController.h"



static NSString *kAuthScope = @"snsapi_userinfo";
//@"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
static NSString *kAuthState = @"kAuthState";
static NSString *kAuthOpenID = @"oiwjW06FGjIYZZdY4AszU3O6hLlk";

@interface WechatLoginViewController ()<WXApiManagerDelegate>

@end

@implementation WechatLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微信登录";
    
    [WXApiManager sharedManager].delegate = self;
    [self setupSubViews];
    
}

- (void)setupSubViews
{
    if ([UIScreen mainScreen].bounds.size.width == 375) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg_ip6"]];
    }else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]];
    }
    
//    if ([WXApi isWXAppInstalled]) {
        [self createWechatView];
//    }else{
        // 没有安装微信，游客登录
//        [self createTouristView];
//    }
    
}

#pragma mark - 游客登录样式
- (void)createTouristView
{
    // 版权声明
    UILabel *copyLabel = [[UILabel alloc]init];
    copyLabel.text = @"Copyright ©2017 佛缘生活";
    copyLabel.textColor = MainColor;
    copyLabel.userInteractionEnabled = YES;
    copyLabel.textAlignment = NSTextAlignmentCenter;
    copyLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:copyLabel];
    [copyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-18);
        make.height.equalTo(@25);
    }];
    
    // 游客登录
    UIView *touristView = [[UIView alloc]initWithFrame:CGRectZero];
    touristView.backgroundColor = MainColor;
    touristView.userInteractionEnabled = YES;
    touristView.layer.masksToBounds = YES;
    touristView.layer.cornerRadius = 24;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [WXApiRequestHandler sendAuthRequestScope:kAuthScope
                                            State:kAuthState
                                           OpenID:kAuthOpenID
                                 InViewController:self];
    }];
    [touristView addGestureRecognizer:tap];
    [self.view addSubview:touristView];
    [touristView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(copyLabel.mas_top).offset(-20);
        make.left.equalTo(self.view.mas_left).offset(60);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@48);
    }];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.text = @"微信登录";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    label.textAlignment = NSTextAlignmentCenter;
    [touristView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(touristView.mas_centerX);
        make.centerY.equalTo(touristView.mas_centerY);
        make.height.equalTo(@30);
    }];
    
}

#pragma mark - 微信登录样式
- (void)createWechatView
{
    // 版权声明
    UILabel *copyLabel = [[UILabel alloc]init];
    copyLabel.text = @"Copyright ©2017 佛缘生活";
    copyLabel.textColor = MainColor;
    copyLabel.userInteractionEnabled = YES;
    copyLabel.textAlignment = NSTextAlignmentCenter;
    copyLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:copyLabel];
    [copyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-18);
        make.height.equalTo(@25);
    }];
    
    
    
    // 手机号码登录
    UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [otherButton setTitle:@"手机号码登录" forState:UIControlStateNormal];
    [otherButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        PhoneLoginViewController *registerVC = [PhoneLoginViewController new];
        RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:registerVC];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }];
    otherButton.layer.masksToBounds = YES;
    otherButton.layer.cornerRadius = 24;
    otherButton.layer.borderColor = MainColor.CGColor;
    otherButton.layer.borderWidth = 1.f;
    otherButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [otherButton setTitleColor:MainColor forState:UIControlStateNormal];
    [self.view addSubview:otherButton];
    [otherButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(copyLabel.mas_top).offset(-12);
        make.left.equalTo(self.view.mas_left).offset(40*CKproportion);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@46);
    }];
    
    
    // 微信快速登录
    UIView *wechatView = [[UIView alloc]initWithFrame:CGRectZero];
    wechatView.backgroundColor = MainColor;
    wechatView.userInteractionEnabled = YES;
    wechatView.layer.masksToBounds = YES;
    wechatView.layer.cornerRadius = 24;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self WechatLoginAction];
    }];
    [wechatView addGestureRecognizer:tap];
    [self.view addSubview:wechatView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.text = @"微信快速登录";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    label.textAlignment = NSTextAlignmentCenter;
    [wechatView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wechatView.mas_centerX).offset(10);
        make.centerY.equalTo(wechatView.mas_centerY);
        make.height.equalTo(@30);
    }];
    
    UIImageView *wechatIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
    [wechatIcon setImage:[UIImage imageNamed:@"wechat_login"]];
    [wechatView addSubview:wechatIcon];
    [wechatIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label.mas_left);
        make.centerY.equalTo(wechatView.mas_centerY);
        make.width.and.height.equalTo(@30);
    }];
    
    
    [wechatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(otherButton.mas_top).offset(-15);
        make.left.equalTo(otherButton.mas_left);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@48);
    }];
    
}

#pragma mark - 微信登录
- (void)WechatLoginAction
{
    if (![WXApi isWXAppInstalled]) {
        
#ifdef DEBUG 
        // 处于开发阶段
        [[TTLFManager sharedManager].networkManager simulatorLoginSuccess:^{
            [self loginSuccess];
        } Fail:^(NSString *errorMsg) {
            [self sendAlertAction:errorMsg];
        }];
#else 
        // 处于发布阶段
        [self showTwoAlertWithMessage:@"您尚未安装微信，建议使用手机号登录" ConfirmClick:^{
            PhoneLoginViewController *registerVC = [PhoneLoginViewController new];
            RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:registerVC];
            [self presentViewController:nav animated:YES completion:^{
                
            }];
        }];
#endif
        return;
    }
    
    if (![WXApi isWXAppSupportApi]) {
        [self sendAlertAction:@"您当前的微信版本暂不支持快速登录，请升级到最新版本。"];
        return;
    }
    
    [WXApiRequestHandler sendAuthRequestScope:kAuthScope
                                        State:kAuthState
                                       OpenID:kAuthOpenID
                             InViewController:self];
}

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response
{
    [MBProgressHUD showMessage:nil];
    
    [[TTLFManager sharedManager].networkManager wechatLoginResponse:response Success:^{
        [MBProgressHUD hideHUD];
        [self loginSuccess];
    } Fail:^(NSString *errorMsg) {
        [MBProgressHUD hideHUD];
        [self performSelector:@selector(showMessage:) withObject:errorMsg afterDelay:0.3];
    }];
}

- (void)showMessage:(NSString *)error {
    [self sendAlertAction:error];
}

- (void)loginSuccess
{
    // 去tabbar
    RootTabbarController *tabbar = [[RootTabbarController alloc]init];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    CATransition *animation = [CATransition animation];
    animation.duration = 0.6;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    animation.subtype = kCATransitionFromBottom;
    [self.view.window.layer addAnimation:animation forKey:nil];
    window.rootViewController = tabbar;
    [window makeKeyAndVisible];
    
    // 去礼佛界面
//    LiFoViewController *lifoVC = [[LiFoViewController alloc]init];
//    [TTLFManager sharedManager].lifoVC = lifoVC;
//    RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:lifoVC];
//    UIWindow *window = [UIApplication sharedApplication].delegate.window;
//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.6;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    animation.type = kCATransitionFade;
//    animation.subtype = kCATransitionFromBottom;
//    [self.view.window.layer addAnimation:animation forKey:nil];
//    window.rootViewController = nav;
//    [window makeKeyAndVisible];
}

#pragma mark - 其他
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
