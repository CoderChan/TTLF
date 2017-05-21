//
//  PhoneViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/2/27.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PhoneViewController.h"
#import <LCActionSheet.h>
#import <Masonry.h>

@interface PhoneViewController ()<UITextFieldDelegate,LCActionSheetDelegate>

{
    UIButton *commitBtn;
}

@property (copy,nonatomic) NSString *phoneStr;

/** 没有添加手机的界面属性 **/
@property (strong,nonatomic) UIActivityIndicatorView *indicator1;
@property (strong,nonatomic) UITextField *textField;
@property (strong,nonatomic) UIImageView *xian;
@property (strong,nonatomic) UILabel *label;
/** 已添加手机的界面属性 */
@property (strong,nonatomic) UIImageView *imageV;
@property (strong,nonatomic) UILabel *phoneLabel;
@property (strong,nonatomic) UILabel *descLabel;
@property (strong,nonatomic) UIButton *changePhoneBtn;
@property (strong,nonatomic) UIActivityIndicatorView *indicator2;

@end

@implementation PhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机号码";
    self.view.backgroundColor = [UIColor whiteColor];
    UserInfoModel *model = [[TTLFManager sharedManager].userManager getUserInfo];
    
    if (model.phoneNum.length > 3) {
        self.phoneStr = model.phoneNum;
        [self setupPhoneVies];
    }else{
        [self setupNoPhoneViews];
    }
}

#pragma mark - 没有绑定手机号码的界面
- (void)setupNoPhoneViews
{
    self.label = [[UILabel alloc]initWithFrame:CGRectZero];
    self.label.text = @"请输入有效的手机号";
    self.label.font = [UIFont systemFontOfSize:24];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@24);
        make.top.equalTo(self.view.mas_top).offset(75);
    }];
    
    self.textField = [[UITextField alloc]init];
    self.textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, 0, 40)];
    [self.textField becomeFirstResponder];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.backgroundColor = [UIColor whiteColor];
    if (self.phoneStr) {
        self.textField.placeholder = [NSString stringWithFormat:@"如：%@",self.phoneStr];
    }else{
        self.textField.placeholder = @"如：18233568284";
    }
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label.mas_bottom).offset(45);
        make.left.equalTo(self.view.mas_left).offset(35);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@40);
    }];
    
    self.xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    [self.view addSubview:_xian];
    [_xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField.mas_left);
        make.right.equalTo(self.textField.mas_right);
        make.top.equalTo(self.textField.mas_bottom);
        make.height.equalTo(@2);
    }];
    
    commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.backgroundColor = MainColor;
    [commitBtn setTitle:@"确  定" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [commitBtn addTarget:self action:@selector(sendNewPhone:) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.layer.cornerRadius = 4;
    [self.view addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xian.mas_bottom).offset(40);
        make.left.equalTo(self.view.mas_left).offset(25);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.height.equalTo(@40);
    }];
}

#pragma mark - 点击绑定手机号
- (void)sendNewPhone:(UIButton *)sender
{
    if (self.textField.text.length <= 3) {
        [MBProgressHUD showError:@"手机号码不正确"];
        return;
    }
    if ([self.textField.text isEqualToString:self.phoneStr]) {
        [MBProgressHUD showError:@"手机号无变化"];
        return;
    }
    
    [self.view endEditing:YES];
    
    /************ 上传到自己的服务器 ************/
    [sender setTitle:@"" forState:UIControlStateNormal];
    [self.indicator1 startAnimating];
    [[TTLFManager sharedManager].networkManager updatePhone:self.textField.text Success:^{
        [self.indicator1 stopAnimating];
        [self setupPhoneVies];
    } Fail:^(NSString *errorMsg) {
        [self.indicator1 stopAnimating];
        [MBProgressHUD showError:errorMsg];
    }];
}
#pragma mark - 已绑定的界面
- (void)setupPhoneVies
{
    [self.label removeFromSuperview];
    [self.textField removeFromSuperview];
    [self.xian removeFromSuperview];
    [commitBtn removeFromSuperview];
    
    self.imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"checked_phone"]];
    [self.view addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(138*CKproportion);
        make.width.and.height.equalTo(@160);
    }];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *kkk = [[userDefault objectForKey:@"userPhone"] description];
    if (kkk.length == 11) {
        self.phoneStr = kkk;
    }
    self.phoneLabel = [[UILabel alloc]init];
    if (self.phoneStr) {
        self.phoneLabel.text = [NSString stringWithFormat:@"当前手机号：%@",self.phoneStr];
    }else{
        self.phoneLabel.text = [NSString stringWithFormat:@"当前手机号：%@",self.textField.text];
    }
    self.phoneLabel.font = [UIFont systemFontOfSize:20];
    self.phoneLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.imageV.mas_bottom).offset(20);
        make.height.equalTo(@24);
    }];
    
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.textAlignment = NSTextAlignmentCenter;
    self.descLabel.text = @"此手机号方便您在佛缘生活中\n实现高效沟通";
    self.descLabel.font = [UIFont systemFontOfSize:16];
    self.descLabel.textColor = [UIColor grayColor];
    self.descLabel.numberOfLines = 0;
    [self.view addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.phoneLabel.mas_bottom).offset(14);
        make.height.equalTo(@44);
    }];
    
    self.changePhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.changePhoneBtn setTitle:@"更换手机号" forState:UIControlStateNormal];
    self.changePhoneBtn.backgroundColor = MainColor;
    [self.changePhoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.changePhoneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.changePhoneBtn addTarget:self action:@selector(changePhoneAction:) forControlEvents:UIControlEventTouchUpInside];
    self.changePhoneBtn.layer.cornerRadius = 4;
    [self.view addSubview:self.changePhoneBtn];
    [self.changePhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view.mas_left).offset(25);
        make.top.equalTo(self.descLabel.mas_bottom).offset(16);
        make.height.equalTo(@40);
    }];
}

#pragma mark - 解绑手机号
- (void)changePhoneAction:(UIButton *)sender
{
    
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"确定更改手机号？" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self.indicator2 stopAnimating];
            
            [self.changePhoneBtn removeFromSuperview];
            [self.descLabel removeFromSuperview];
            [self.phoneLabel removeFromSuperview];
            [self.imageV removeFromSuperview];
            
            [self setupNoPhoneViews];
        }
    } otherButtonTitles:@"确定修改", nil];
    sheet.destructiveButtonIndexSet = [NSSet setWithObject:@1];
    [sheet show];
    
}


- (UIActivityIndicatorView *)indicator1
{
    if (!_indicator1) {
        _indicator1 = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [commitBtn addSubview:_indicator1];
        [_indicator1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self->commitBtn.mas_centerX);
            make.centerY.equalTo(self->commitBtn.mas_centerY);
            make.width.and.height.equalTo(@35);
        }];
    }
    return _indicator1;
}

- (UIActivityIndicatorView *)indicator2
{
    if (!_indicator2) {
        _indicator2 = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_changePhoneBtn addSubview:_indicator2];
        [_indicator2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.changePhoneBtn.mas_centerX);
            make.centerY.equalTo(self.changePhoneBtn.mas_centerY);
            make.width.and.height.equalTo(@35);
        }];
    }
    return _indicator2;
}



@end
