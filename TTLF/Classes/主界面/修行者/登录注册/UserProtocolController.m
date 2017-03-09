//
//  UserProtocolController.m
//  YLRM
//
//  Created by Chan_Sir on 2016/12/26.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "UserProtocolController.h"

@interface UserProtocolController ()

@property (strong,nonatomic) UIWebView *webView;

@end

@implementation UserProtocolController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户协议";
    
    self.webView = [[UIWebView alloc]init];
    NSString *str = @"http://member.changyou.com/inc/useragreement.html";
    NSURL *url = [NSURL URLWithString:str];
    self.webView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.webView request];
}



@end
