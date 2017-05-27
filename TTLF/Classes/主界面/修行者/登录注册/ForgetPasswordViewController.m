//
//  ForgetPasswordViewController.m
//  YLRM
//
//  Created by apple on 16/10/10.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import <Masonry.h>
#import <LCActionSheet.h>
#import <SMS_SDK/SMSSDK.h>


@interface ForgetPasswordViewController ()<UITextFieldDelegate>

{
    int ReGetCodeNum; // 重新获取验证码时间间隔
    dispatch_source_t _timer;
}


/** 手机号码 */
@property (strong,nonatomic) UITextField *phoneField;
/** 验证码 */
@property (strong,nonatomic) UITextField *codeField;
/** 验证码按钮 */
@property (strong,nonatomic) UIButton *codeButton;


/** 密码1 */
@property (strong,nonatomic) UITextField *passWord1;
/** 密码2 */
@property (strong,nonatomic) UITextField *passWord2;


@end

@implementation ForgetPasswordViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"忘记密码";
    [self setupSubViews];
    
}


- (void)setupSubViews
{
    
    
    
    UIView *leftV1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    
    UIImageView *phoneIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_phone"]];
    phoneIcon.backgroundColor = [UIColor whiteColor];
    phoneIcon.frame = CGRectMake(12, 7, 30, 30);
    [leftV1 addSubview:phoneIcon];
    
    // 手机号码
    self.phoneField = [[UITextField alloc]initWithFrame:CGRectMake(30, 25, self.view.width - 60, 40)];
    self.phoneField.delegate = self;
    self.phoneField.tintColor = [UIColor blackColor];
    self.phoneField.placeholder = @"注册手机号";
    self.phoneField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.phoneField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneField.leftView = leftV1;
    self.phoneField.backgroundColor = [UIColor whiteColor];
    self.phoneField.layer.masksToBounds = YES;
    self.phoneField.layer.cornerRadius = 4;
    self.phoneField.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
    self.phoneField.layer.borderWidth = 1.f;
    self.phoneField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.phoneField];
    
    // 验证码
    self.codeField = [[UITextField alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.phoneField.frame) + 15, (self.view.width - 60) * 0.7, 40)];
    self.codeField.delegate = self;
    self.codeField.tintColor = [UIColor blackColor];
    self.codeField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.backgroundColor = [UIColor whiteColor];
    self.codeField.layer.masksToBounds = YES;
    self.codeField.layer.cornerRadius = 4;
    self.codeField.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
    self.codeField.layer.borderWidth = 1.f;
    self.codeField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.codeField];
    
    // 获取验证码
    self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.codeButton.backgroundColor = [UIColor whiteColor];
    self.codeButton.frame = CGRectMake(CGRectGetMaxX(self.codeField.frame) + 10, CGRectGetMaxY(self.phoneField.frame) + 15, (self.view.width - 60) * 0.3 - 10, 40);
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.codeButton setTitleColor:MainColor forState:UIControlStateNormal];
    self.codeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.codeButton addTarget:self action:@selector(getCodeNumAction) forControlEvents:UIControlEventTouchUpInside];
    self.codeButton.layer.masksToBounds = YES;
    self.codeButton.layer.cornerRadius = 4;
    [self.view addSubview:self.codeButton];
    
    // 密码1
    self.passWord1 = [[UITextField alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.codeField.frame) + 15, self.view.width - 60, 40)];
    self.passWord1.secureTextEntry = YES;
    self.passWord1.delegate = self;
    self.passWord1.placeholder = @"输入新密码";
    self.passWord1.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.passWord1.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    self.passWord1.tintColor = [UIColor blackColor];
    self.passWord1.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *leftV2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    UIImageView *phoneV2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_pass"]];
    phoneV2.frame = CGRectMake(12, 7, 30, 30);
    [leftV2 addSubview:phoneV2];
    self.passWord1.leftView = leftV2;
    self.passWord1.backgroundColor = [UIColor whiteColor];
    self.passWord1.layer.masksToBounds = YES;
    self.passWord1.layer.cornerRadius = 4;
    self.passWord1.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
    self.passWord1.layer.borderWidth = 1.f;
    self.passWord1.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.passWord1];
    
    // 密码2
    self.passWord2 = [[UITextField alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.passWord1.frame) + 15, self.view.width - 60, 40)];
    self.passWord2.secureTextEntry = YES;
    self.passWord2.delegate = self;
    self.passWord2.placeholder = @"确认新密码";
    self.passWord2.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.passWord2.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    self.passWord2.tintColor = [UIColor blackColor];
    self.passWord2.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *leftV3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    UIImageView *phoneV3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_pass"]];
    phoneV3.frame = CGRectMake(12, 7, 30, 30);
    [leftV3 addSubview:phoneV3];
    self.passWord2.leftView = leftV3;
    self.passWord2.backgroundColor = [UIColor whiteColor];
    self.passWord2.layer.masksToBounds = YES;
    self.passWord2.layer.cornerRadius = 4;
    self.passWord2.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
    self.passWord2.layer.borderWidth = 1.f;
    self.passWord2.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.passWord2];
    
    
    
    
    // 修改按钮
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.backgroundColor = MainColor;
    [registerButton setTitle:@"确定修改" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [registerButton addTarget:self action:@selector(changePassAction) forControlEvents:UIControlEventTouchUpInside];
    registerButton.layer.masksToBounds = YES;
    registerButton.layer.cornerRadius = 4;
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passWord2.mas_left);
        make.right.equalTo(self.passWord2.mas_right);
        make.top.equalTo(self.passWord2.mas_bottom).offset(50);
        make.height.equalTo(@44);
    }];
}

- (void)getCodeNumAction
{
    [self.view endEditing:YES];
    
    if (![self.phoneField.text isPhoneNum]) {
        [self showPopTipsWithMessage:@"号码有误" AtView:self.phoneField inView:self.view];
        return;
    }
    
    self.codeButton.enabled = NO;
    [self openCountdown];
    
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            [MBProgressHUD showSuccess:@"已发送至您的手机"];
            [self.codeField becomeFirstResponder];
            
            // 恢复按钮
            [self.codeButton setTitleColor:MainColor forState:UIControlStateNormal];
            [self.codeButton setTitle:@"重新获取" forState:UIControlStateNormal];
            self.codeButton.enabled = YES;
        }else{
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.codeButton setTitleColor:MainColor forState:UIControlStateNormal];
                self.codeButton.enabled = YES;
                [MBProgressHUD showError:error.localizedDescription];
            });
        }
    }];
}

- (void)openCountdown
{
    __block NSInteger time = ReGetCodeNum; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.codeButton setTitleColor:MainColor forState:UIControlStateNormal];
                self.codeButton.enabled = YES;
            });
            
        }else{
            
            int seconds = time % ReGetCodeNum;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.codeButton setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.codeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                self.codeButton.enabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

- (void)changePassAction
{
    [self.view endEditing:YES];
    
    if (![self.phoneField.text isPhoneNum]) {
        [self showPopTipsWithMessage:@"号码有误" AtView:self.phoneField inView:self.view];
        return;
    }
    if (self.codeField.text.length <= 3) {
        [self showPopTipsWithMessage:@"验证码有误" AtView:self.codeField inView:self.view];
        return;
    }
    if (self.passWord1.text.length < 6) {
        [self showPopTipsWithMessage:@"密码最少6位长度" AtView:self.passWord1 inView:self.view];
        return;
    }
    if (self.passWord2.text.length < 6) {
        [self showPopTipsWithMessage:@"密码最少6位长度" AtView:self.passWord2 inView:self.view];
        return;
    }
    if (![self.passWord1.text isEqualToString:self.passWord2.text]) {
        [self showPopTipsWithMessage:@"两次输密不一致" AtView:self.passWord1 inView:self.view];
        [self showPopTipsWithMessage:@"两次输密不一致" AtView:self.passWord2 inView:self.view];
        return;
    }
    
    [SMSSDK commitVerificationCode:self.codeField.text phoneNumber:self.phoneField.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        if (!error) {
    
            // 开始注册账号
            [MBProgressHUD showMessage:@""];
            [[TTLFManager sharedManager].networkManager setNewPassWord:self.phoneField.text Pass:self.passWord2.text Success:^{
                [MBProgressHUD hideHUD];
                [self showOneAlertWithMessage:@"新密码设置成功，请重新登录" ConfirmClick:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            } Fail:^(NSString *errorMsg) {
                [MBProgressHUD hideHUD];
                [self sendAlertAction:errorMsg];
            }];
            
        }else{
            [self mobErrorAction:error Completion:^(NSString *errorTip) {
                [self sendAlertAction:errorTip];
            }];
            
        }
    }];
    
    
}

- (void)mobErrorAction:(NSError *)mobError Completion:(void (^)(NSString *errorTip))completion
{
    NSInteger code = mobError.code;
    switch (code) {
        case 468:
            completion(@"验证码错误或验证间隔时间太短，请重新获取。");
            break;
        case 400:
            completion(@"手机端请求不能被识别");
            break;
        case 405:
            completion(@"请求的AppKey为空");
            break;
        case 406:
            completion(@"请求的AppKey不存在");
            break;
        case 407:
            completion(@"请求提交的数据缺少必要的数据");
            break;
        case 408:
            completion(@"无效的请求参数");
            break;
        case 418:
            completion(@"内部接口调用失败");
            break;
        case 450:
            completion(@"无权执行该操作");
            break;
        case 454:
            completion(@"请求传递的数据格式错误，服务器无法转换为JSON格式的数据");
            break;
        case 457:
            completion(@"提交的手机号格式不正确（包括手机的区号）");
            break;
        case 456:
            completion(@"提交的手机号码或者区号为空");
            break;
        case 458:
            completion(@"手机号码在黑名单中");
            break;
        case 470:
            completion(@"账户的短信余额不足");
            break;
        case 467:
            completion(@"校验验证码请求频繁	5分钟内校验错误超过3次，验证码失效");
            break;
        case 465:
            completion(@"手机号码在APP中每天发送短信的数量超限");
            break;
        case 464:
            completion(@"每台手机每天发送短信的次数超限");
            break;
        case 463:
            completion(@"手机号码在当前APP内每天发送短信的次数超出限制");
            break;
        case 472:
            completion(@"客户端请求发送短信验证过于频繁");
            break;
        case 475:
            completion(@"appKey的应用信息不存在");
            break;
            
        default:
            completion(mobError.localizedDescription);
            break;
    }
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



@end
