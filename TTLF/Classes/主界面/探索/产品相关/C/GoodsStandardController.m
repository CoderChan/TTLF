//
//  GoodsStandardController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/26.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "GoodsStandardController.h"
#import "CMPopTipView.h"

@interface GoodsStandardController ()

@property (strong,nonatomic) GoodsInfoModel *model;

@property (strong,nonatomic) UIWebView *webView;

@end

@implementation GoodsStandardController

- (instancetype)initWithModel:(GoodsInfoModel *)model
{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品规格";
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.webView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.webView];
    
    [self.webView loadHTMLString:self.model.standard baseURL:[NSURL URLWithString:@"app.yangruyi.com"]];
    
}

@end
