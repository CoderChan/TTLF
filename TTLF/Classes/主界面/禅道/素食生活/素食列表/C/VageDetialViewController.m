//
//  VageDetialViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/7.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "VageDetialViewController.h"
#import "RightMoreView.h"



@interface VageDetialViewController ()<RightMoreViewDelegate>

@end

@implementation VageDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"素食详情";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"rightbar_more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)moreAction
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    RightMoreView *moreView = [[RightMoreView alloc]initWithFrame:keyWindow.bounds];
    moreView.delegate = self;
    [keyWindow addSubview:moreView];
}
- (void)rightMoreViewWithClickType:(MoreItemClickType)clickType
{
    
}

@end
