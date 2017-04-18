//
//  DetialNewsViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/18.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "DetialNewsViewController.h"
#import "CommentRightBarView.h"

@interface DetialNewsViewController ()<UIWebViewDelegate>

@property (strong,nonatomic) UIWebView *webView;

@end

@implementation DetialNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
}
#pragma mark - 绘制界面
- (void)setupSubViews
{
    CommentRightBarView *rightView = [[CommentRightBarView alloc]initWithFrame:CGRectMake(self.view.width - 80, 0, 80, 50)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.webView.backgroundColor = self.view.backgroundColor;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://fo.ifeng.com/a/20170418/44575301_0.shtml"]];
    [self.webView loadRequest:request];
}

#pragma mark - 其他方法
- (void)commentAction
{
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    KGLog(@"error = %@",error.localizedDescription);
}

@end
