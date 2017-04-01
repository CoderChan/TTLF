//
//  ZuoCanViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/1.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "ZuoCanViewController.h"

@interface ZuoCanViewController ()

@end

@implementation ZuoCanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"坐禅冥想";
    [self setupSubViews];
}

- (void)setupSubViews
{
    if (SCREEN_WIDTH == 375) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"yueguang_bg_ip6"]];
    }else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"yueguang_bg"]];
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
