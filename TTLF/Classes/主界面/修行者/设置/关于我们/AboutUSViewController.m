//
//  AboutUSViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/1/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AboutUSViewController.h"


@interface AboutUSViewController ()<UIWebViewDelegate>

@property (strong,nonatomic) UIWebView *webView;

@end

@implementation AboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, SCREEN_HEIGHT - 64)];
    NSURL *url = [NSURL URLWithString:OfficalWebURL];
//    NSString *js_fit_code = [NSString stringWithFormat:@"var meta = document.createElement('meta');"
//                             "meta.name = 'viewport';"
//                             "meta.content = 'width=device-width, initial-scale=1.0,minimum-scale=1, maximum-scale=2.0, user-scalable=yes';"
//                             "document.getElementsByTagName('head')[0].appendChild(meta);"
//                             ];
//    
//    [self.webView stringByEvaluatingJavaScriptFromString:js_fit_code];
    [self.webView sizeToFit];
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.webView request];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sharedAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD showError:error.localizedDescription];
}

- (void)sharedAction
{
    NSURL *url = [NSURL URLWithString:OfficalWebURL];
    
    UIActivityViewController *activeVC = [[UIActivityViewController alloc]initWithActivityItems:@[url] applicationActivities:nil];
    [self presentViewController:activeVC animated:YES completion:^{
        
    }];
}



@end
