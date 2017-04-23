//
//  ShareVageViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/23.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "ShareVageViewController.h"
#import "VageNextStepController.h"

@interface ShareVageViewController ()

@end

@implementation ShareVageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享素食";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"dismiss"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStepAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:MainColor];
    
}


- (void)dismissAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)nextStepAction
{
    VageNextStepController *nextStep = [VageNextStepController new];
    [self.navigationController pushViewController:nextStep animated:YES];
}

@end
