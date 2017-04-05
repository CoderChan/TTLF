//
//  VegeViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/4.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "VegeViewController.h"

@interface VegeViewController ()

@end

@implementation VegeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"素食生活";
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"right_cook"] style:UIBarButtonItemStylePlain target:self action:@selector(addVegeAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    // 1、上部
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width/2, (self.view.height - 64)*0.4)];
    leftView.userInteractionEnabled = YES;
    leftView.backgroundColor = RGBACOLOR(239, 182, 81, 1);
    [self.view addSubview:leftView];
    
    // 食材市场
    UIImageView *iconView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vege_list"]];
    iconView1.frame = CGRectMake((leftView.width - 80)/2, (leftView.height - 80)/2 - 20, 80, 80);
    [leftView addSubview:iconView1];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconView1.frame) + 5, leftView.width, 30)];
    label1.text = @"精选素食";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont boldSystemFontOfSize:23];
    label1.textColor = [UIColor whiteColor];
    [leftView addSubview:label1];
    
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [MBProgressHUD showSuccess:@"精选食材"];
    }];
    [leftView addGestureRecognizer:leftTap];
    
    // 食材收藏
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(self.view.width/2, 0, self.view.width/2, leftView.height)];
    rightView.backgroundColor = leftView.backgroundColor;
    rightView.userInteractionEnabled = YES;
    [self.view addSubview:rightView];
    
    UIImageView *iconView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vege_store"]];
    iconView2.frame = CGRectMake((rightView.width - 80)/2, (rightView.height - 80)/2 - 20, 80, 80);
    [rightView addSubview:iconView2];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconView2.frame) + 5, rightView.width, 30)];
    label2.text = @"素食收藏";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont boldSystemFontOfSize:23];
    label2.textColor = [UIColor whiteColor];
    [rightView addSubview:label2];
    
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [MBProgressHUD showError:@"食材收藏"];
    }];
    [rightView addGestureRecognizer:rightTap];
    
    
    // 2、下部
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(leftView.frame), self.view.width, (self.view.height - 64) * 0.6)];
    bottomView.backgroundColor = RGBACOLOR(60, 68, 106, 1);
    bottomView.userInteractionEnabled = YES;
    [self.view addSubview:bottomView];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vege_guo"]];
    imageView.frame = CGRectMake(self.view.width/2 - 90*CKproportion, bottomView.height/2 - 90*CKproportion, 180*CKproportion, 180*CKproportion);
    [bottomView addSubview:imageView];
    
    
}

- (void)addVegeAction
{
    [MBProgressHUD showStore:@"美食秘诀" Type:YES];
}

@end
