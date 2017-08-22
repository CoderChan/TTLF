//
//  PaySuccessController.m
//  TTLF
//
//  Created by YRJSB on 2017/8/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PaySuccessController.h"
#import <Masonry.h>


@interface PaySuccessController ()

@end

@implementation PaySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付成功";
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // 完成图标
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pay_success"]];
    [self.view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-50);
        make.width.and.height.equalTo(@60);
    }];
    
    // 完成按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"完成支付" forState:UIControlStateNormal];
    [button setTitleColor:GreenColor forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.borderColor = GreenColor.CGColor;
    button.layer.borderWidth = 1.f;
    button.layer.cornerRadius = 4;
    [button addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(iconView.mas_bottom).offset(40);
        make.height.equalTo(@40);
        make.width.equalTo(@(240*CKproportion));
    }];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissAction)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
}

- (void)dismissAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
