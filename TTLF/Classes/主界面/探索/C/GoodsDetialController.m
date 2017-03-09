//
//  GoodsDetialController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/1/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "GoodsDetialController.h"

@interface GoodsDetialController ()<UIWebViewDelegate>

@property (strong,nonatomic) UIWebView *webView;

@end

@implementation GoodsDetialController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"饰品详情";
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, SCREEN_HEIGHT - 64)];
    self.webView.delegate = self;
    NSString *js_fit_code = [NSString stringWithFormat:@"var meta = document.createElement('meta');"
                             "meta.name = 'viewport';"
                             "meta.content = 'width=device-width, initial-scale=1.0,minimum-scale=1, maximum-scale=2.0, user-scalable=yes';"
                             "document.getElementsByTagName('head')[0].appendChild(meta);"
                             ];
    
    [self.webView stringByEvaluatingJavaScriptFromString:js_fit_code];
    [self.webView sizeToFit];
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.webView];
    NSURL *url = [NSURL URLWithString:TaobaoGoodsURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"淘宝" style:UIBarButtonItemStylePlain target:self action:@selector(goForwardAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
}
- (void)goForwardAction
{
    [self.webView goForward];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD showError:error.localizedDescription];
}

@end
