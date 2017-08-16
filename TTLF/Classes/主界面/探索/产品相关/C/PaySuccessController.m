//
//  PaySuccessController.m
//  TTLF
//
//  Created by YRJSB on 2017/8/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PaySuccessController.h"

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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"完成支付" forState:UIControlStateNormal];
    [button setTitleColor:GreenColor forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.borderColor = GreenColor.CGColor;
    button.layer.borderWidth = 1.f;
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
       [self.navigationController dismissViewControllerAnimated:YES completion:^{
           
       }];
    }];
    [self.view addSubview:button];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissAction)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)dismissAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
