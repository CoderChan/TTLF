//
//  RegisterViewController.m
//  YLRM
//
//  Created by apple on 16/10/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//  注册

#import "RegisterViewController.h"
#import "UserProtocolController.h"
#import <Masonry.h>
#import <SMS_SDK/SMSSDK.h>
#import <LCActionSheet.h>



@interface RegisterViewController ()


{
    int ReGetCodeNum; // 重新获取验证码时间间隔
    dispatch_source_t _timer;
}

@property (strong,nonatomic) UIButton *areaButton;

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



@implementation RegisterViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    //布局导航栏
    self.title = @"注册";
    
    ReGetCodeNum = 60;
    
    [self setupSubViews];
    
}


-(void)setupSubViews{
    
    
    self.areaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.areaButton.frame = CGRectMake(0, 0, 50, 40);
    self.areaButton.backgroundColor = [UIColor whiteColor];
    [self.areaButton setTitle:@"86" forState:UIControlStateNormal];
    [self.areaButton setTitleColor:NavColor forState:UIControlStateNormal];
    self.areaButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.areaButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton *sender) {
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"选择号码区域" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [sender setTitle:@"86" forState:UIControlStateNormal];
            }else if (buttonIndex == 2){
                [sender setTitle:@"852" forState:UIControlStateNormal];
            }else if (buttonIndex == 3){
                [sender setTitle:@"853" forState:UIControlStateNormal];
            }else if (buttonIndex == 4){
                [sender setTitle:@"886" forState:UIControlStateNormal];
            }else if (buttonIndex == 5){
                [sender setTitle:@"1" forState:UIControlStateNormal];
            }
        } otherButtonTitles:@"中国大陆 86",@"香港 852",@"澳门 853",@"台湾 886",@"USA 1", nil];
        [sheet show];
    }];
    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(45.5, 5, 0.5, 30)];
    xian.backgroundColor = [UIColor lightGrayColor];
    xian.alpha = 0.6;
    [self.areaButton addSubview:xian];
    
    // 手机号码
    self.phoneField = [[UITextField alloc]initWithFrame:CGRectMake(30, 25, self.view.width - 60, 40)];
    self.phoneField.tintColor = [UIColor blackColor];
    self.phoneField.placeholder = @"手机号码";
    self.phoneField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.phoneField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.phoneField.leftView = self.areaButton;
    self.phoneField.backgroundColor = [UIColor whiteColor];
    self.phoneField.layer.masksToBounds = YES;
    self.phoneField.layer.cornerRadius = 4;
    self.phoneField.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
    self.phoneField.layer.borderWidth = 1.f;
    self.phoneField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.phoneField];
    
    // 验证码
    self.codeField = [[UITextField alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.phoneField.frame) + 15, (self.view.width - 60) * 0.7, 40)];
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
    self.passWord1.placeholder = @"输入密码";
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
    self.passWord2.placeholder = @"确认密码";
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
    
    
    // 注册按钮
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.backgroundColor = MainColor;
    [registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [registerButton addTarget:self action:@selector(RegisterAction) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - 获取验证码
- (void)getCodeNumAction
{
    [self.view endEditing:YES];
    
    if (self.phoneField.text.length < 3) {
        [MBProgressHUD showError:@"手机号码不正确"];
        return;
    }
    
    self.codeButton.enabled = NO;
    [self openCountdown];
    
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneField.text zone:self.areaButton.titleLabel.text customIdentifier:nil result:^(NSError *error) {
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

// 开启倒计时效果
- (void)openCountdown{
    
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
#pragma mark - 立即注册
-(void)RegisterAction{
    
    [self.view endEditing:YES];
    if (self.phoneField.text.length <= 3) {
        [MBProgressHUD showError:@"手机号码不正确"];
        return;
    }
    if (self.codeField.text.length <= 3) {
        [MBProgressHUD showError:@"验证码不正确"];
        return;
    }
    if (self.passWord1.text.length < 6 || self.passWord2.text.length != 6) {
        [MBProgressHUD showError:@"密码最少6位长度"];
        return;
    }
    if (![self.passWord1.text isEqualToString:self.passWord2.text]) {
        [MBProgressHUD showError:@"两次密码不一致"];
        return;
    }
    
    [SMSSDK commitVerificationCode:self.codeField.text phoneNumber:self.phoneField.text zone:self.areaButton.titleLabel.text result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        if (!error) {
            
            // 开始注册账号
            [[TTLFManager sharedManager].networkManager registerByPhone:self.phoneField.text Pass:self.passWord2.text Success:^{
                [self sendAlertAction:@"注册成功"];
            } Fail:^(NSString *errorMsg) {
                [self sendAlertAction:errorMsg];
            }];
            
        }else{
            [self sendAlertAction:error.localizedDescription];
        }
    }];
     
    
}



@end
