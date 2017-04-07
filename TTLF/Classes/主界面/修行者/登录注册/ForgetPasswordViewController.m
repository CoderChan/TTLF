//
//  ForgetPasswordViewController.m
//  YLRM
//
//  Created by apple on 16/10/10.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import <Masonry.h>


@interface ForgetPasswordViewController ()

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
    // 手机号码
    self.phoneField = [[UITextField alloc]initWithFrame:CGRectMake(30, 25, self.view.width - 60, 40)];
    self.phoneField.tintColor = [UIColor blackColor];
    self.phoneField.placeholder = @"注册手机号";
    self.phoneField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.phoneField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *leftV1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    UIImageView *phoneV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_phone"]];
    phoneV.frame = CGRectMake(12, 7, 30, 30);
    [leftV1 addSubview:phoneV];
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

- (void)getCodeNumAction
{
    [MBProgressHUD showSuccess:@"获取验证码"];
}
- (void)RegisterAction
{
    [MBProgressHUD showSuccess:@"修改密码"];
}
@end
