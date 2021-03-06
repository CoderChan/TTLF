//
//  PhoneLoginViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/2/24.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PhoneLoginViewController.h"
#import "RegisterViewController.h"
#import <Masonry.h>
#import "ForgetPasswordViewController.h"
#import "RootNavgationController.h"

@interface PhoneLoginViewController ()<UITextFieldDelegate>
{
    UIButton *clickButton;
}
/** 菊花圈 */
@property (nonatomic, strong) UIActivityIndicatorView *indicatorV;
/** 头像 */
@property (strong,nonatomic) UIImageView *headImageV;
/** 账号 */
@property (strong,nonatomic) UITextField *phoneField;
/** 密码 */
@property (strong,nonatomic) UITextField *passField;

@end

@implementation PhoneLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机登录";
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    UIImage *image;
    if (self.view.width == 375) {
        image = [UIImage imageNamed:@"cm2_fm_bg_ip6"];
    }else{
        image = [UIImage imageNamed:@"cm2_fm_bg"];
    }
    UIImageView *backImage = [[UIImageView alloc]initWithImage:image];
    backImage.frame = CGRectMake(0, 0, self.view.width, [UIScreen mainScreen].bounds.size.height);
    backImage.userInteractionEnabled = YES;
    [self.view addSubview:backImage];
    
    backImage.image = [UIImage boxblurImage:image withBlurNumber:0.15];
    
    // 关闭
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissBtn setImage:[UIImage imageNamed:@"dismiss"] forState:UIControlStateNormal];
    [dismissBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [dismissBtn setFrame:CGRectMake(18, 30, 40, 40)];
    [backImage addSubview:dismissBtn];
    
    if (![WXApi isWXAppInstalled]) {
        dismissBtn.hidden = YES;
    }
    
    // 头像
    self.headImageV = [[UIImageView alloc]init];
    self.headImageV.image = [UIImage imageNamed:@"user_place"];
    [backImage addSubview:self.headImageV];
    self.headImageV.layer.masksToBounds = YES;
    self.headImageV.layer.cornerRadius = 45;
    self.headImageV.contentMode = UIViewContentModeScaleAspectFill;
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImage.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(95*CKproportion);
        make.width.equalTo(@90);
        make.height.equalTo(@90);
    }];
    
    
    self.phoneField = [[UITextField alloc]init];
    self.phoneField.delegate = self;
    self.phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneField.borderStyle = UITextBorderStyleNone;
    self.phoneField.background = [UIImage imageNamed:@"userImage"];
    self.phoneField.textAlignment = NSTextAlignmentCenter;
    self.phoneField.placeholder = @"手机号码";
    self.phoneField.tag = 43;
    self.phoneField.tintColor = [UIColor whiteColor];
    self.phoneField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneField.textColor = [UIColor whiteColor];
    self.phoneField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.phoneField.placeholder attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.phoneField.attributedText = [[NSAttributedString alloc]initWithString:self.phoneField.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [backImage addSubview:self.phoneField];
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageV.mas_bottom).offset(50*CKproportion);
        make.left.equalTo(backImage.mas_left).offset(40);
        make.right.equalTo(backImage.mas_right).offset(-40);
        make.height.equalTo(@40);
    }];
    
    self.passField = [[UITextField alloc]init];
    self.passField.delegate = self;
    self.passField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passField.borderStyle = UITextBorderStyleNone;
    self.passField.background = [UIImage imageNamed:@"passworkImage"];
    self.passField.textAlignment = NSTextAlignmentCenter;
    self.passField.placeholder = @"账户密码";
    self.passField.secureTextEntry = YES;
    self.passField.tag = 44;
    self.passField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.passField.tintColor = [UIColor whiteColor];
    self.passField.textColor = [UIColor whiteColor];
    self.passField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.passField.placeholder attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.passField.attributedText = [[NSAttributedString alloc]initWithString:self.passField.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [backImage addSubview:self.passField];
    [self.passField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneField.mas_bottom).offset(10);
        make.left.equalTo(backImage.mas_left).offset(40);
        make.right.equalTo(backImage.mas_right).offset(-40);
        make.height.equalTo(@40);
    }];
    
    
    clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clickButton setTitle:@"登  录" forState:UIControlStateNormal];
    [clickButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    clickButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [clickButton addTarget:self action:@selector(loginSuccess) forControlEvents:UIControlEventTouchUpInside];
    clickButton.layer.masksToBounds = YES;
    clickButton.layer.cornerRadius = 4;
    clickButton.backgroundColor = MainColor;
    [backImage addSubview:clickButton];
    [clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImage.mas_left).offset(40);
        make.right.equalTo(backImage.mas_right).offset(-40);
        make.height.equalTo(@44);
        make.top.equalTo(self.passField.mas_bottom).offset(50*CKproportion);
    }];
    
    // 26 180 8
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitle:@"一键注册" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitleColor:MainColor forState:UIControlStateNormal];
    registerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [backImage addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backImage.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-15);
        make.height.equalTo(@21);
    }];
    
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetButton addTarget:self action:@selector(forgetPassAction) forControlEvents:UIControlEventTouchUpInside];
    [forgetButton setTitleColor:MainColor forState:UIControlStateNormal];
    forgetButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [backImage addSubview:forgetButton];
    [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImage.mas_left).offset(10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-15);
        make.height.equalTo(@21);
    }];
    
#ifdef DEBUG // 处于开发阶段
    self.phoneField.text = @"13522705114";
    self.passField.text = @"888888";
#else // 处于发布阶段
    self.phoneField.text = nil;
    self.passField.text = nil;
#endif
    
}

#pragma mark - 登录注册
- (void)loginSuccess
{
    
    [self.view endEditing:YES];
    if (![self.phoneField.text isPhoneNum]) {
        [self showPopTipsWithMessage:@"号码有误" AtView:self.phoneField inView:self.view];
        return;
    }
    if (self.passField.text.length < 6) {
        [self showPopTipsWithMessage:@"密码有误" AtView:self.passField inView:self.view];
        return;
    }
    
    [MBProgressHUD showMessage:nil];
    [[TTLFManager sharedManager].networkManager loginByPhone:self.phoneField.text Pass:self.passField.text Success:^{
        [MBProgressHUD hideHUD];
        [self loginSuccessAction];
    } Fail:^(NSString *errorMsg) {
        [MBProgressHUD hideHUD];
        [self sendAlertAction:errorMsg];
    }];
    
}

- (void)loginSuccessAction
{
    
//     去tabbar
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text containsString:@" "]) {
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text containsString:@" "]) {
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return YES;
}


- (void)forgetPassAction
{
    ForgetPasswordViewController *forget = [ForgetPasswordViewController new];
    [self.navigationController pushViewController:forget animated:YES];
}

- (void)registerAction
{
    RegisterViewController *registerVC = [RegisterViewController new];
    [self.navigationController pushViewController:registerVC animated:YES];
}
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




@end
