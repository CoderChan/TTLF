//
//  NickNameViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/1/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "NickNameViewController.h"
#import <Masonry.h>

@interface NickNameViewController ()

@property (strong,nonatomic) UITextField *nameField;

@property (strong,nonatomic) UIActivityIndicatorView *indicatorV;

@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改昵称";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(25, 75, self.view.width - 50, 30)];
    label.text = @"取一个好昵称";
    label.font = [UIFont systemFontOfSize:24];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    self.nameField = [[UITextField alloc]initWithFrame:CGRectZero];
    self.nameField.text = [[TTLFManager sharedManager].userManager getUserInfo].nickName;
    self.nameField.placeholder = @"如：我在终南山下";
    self.nameField.backgroundColor = [UIColor clearColor];
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self.view addSubview:self.nameField];
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(35);
        make.top.equalTo(label.mas_bottom).offset(35);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@40);
    }];
    
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    [self.view addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameField.mas_left);
        make.top.equalTo(self.nameField.mas_bottom);
        make.right.equalTo(self.nameField.mas_right);
        make.height.equalTo(@2);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = MainColor;
    [button setTitle:@"确  定" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton *sender) {
        [self.view endEditing:YES];
        if ([self.nameField.text isEqualToString:[[TTLFManager sharedManager].userManager getUserInfo].nickName] || self.nameField.text.length == 0) {
            [MBProgressHUD showError:@"输入有误"];
            return ;
        }
        [sender setTitle:@"" forState:UIControlStateNormal];
        [self.indicatorV startAnimating];
        [[TTLFManager sharedManager].networkManager updateNickName:self.nameField.text Success:^{
            [self.indicatorV stopAnimating];
            [sender setTitle:@"确  定" forState:UIControlStateNormal];
            [self.navigationController popViewControllerAnimated:YES];
        } Fail:^(NSString *errorMsg) {
            [self.indicatorV stopAnimating];
            [sender setTitle:@"确  定" forState:UIControlStateNormal];
            [MBProgressHUD showError:errorMsg];
        }];
        
    }];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(25);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(xian.mas_bottom).offset(40);
    }];
    
    [button addSubview:self.indicatorV];
    [self.indicatorV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button.mas_centerX);
        make.centerY.equalTo(button.mas_centerY);
        make.width.and.height.equalTo(@33);
    }];
    
}

- (UIActivityIndicatorView *)indicatorV
{
    if (!_indicatorV) {
        _indicatorV = [[UIActivityIndicatorView alloc]init];
        _indicatorV.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    return _indicatorV;
}

@end
