//
//  LiFoViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/1/20.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "LiFoViewController.h"
#import <Masonry.h>
#import "ChangePusaViewController.h"
#import "RootNavgationController.h"

@interface LiFoViewController ()

/** 菩萨图 */
@property (strong,nonatomic) UIImageView *pusaImageView;
/** 发光图 */
@property (strong,nonatomic) UIImageView *lightImageView;

@end

@implementation LiFoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
}

- (void)setupSubViews
{
    // 1、背景
    if (self.view.width == 375) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tiantianfo_bg_ip6"]];
    }else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tiantianfo_bg"]];
    }
    
    // 2、 发光
    self.lightImageView = [[UIImageView alloc]init];
    self.lightImageView.image = [UIImage imageNamed:@"gy_lifo_light_01"];
    [self.view addSubview:self.lightImageView];
    CABasicAnimation *rotationAnimation = rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 6;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100000;
    [self.lightImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];//开始动画
    [self.lightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(-3);
        make.top.equalTo(self.view.mas_top);
        make.width.and.height.equalTo(@180);
    }];
    //    [self.lightImageView.layer removeAnimationForKey:@"rotationAnimation"]//结束动画
    
    // 太阳
    UIImageView *_loadingView2 = [[UIImageView alloc]init];
    _loadingView2.image = [UIImage imageNamed:@"gy_lifo_light_02"];
    [self.view addSubview:_loadingView2];
    CABasicAnimation *rotationAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation2.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation2.duration = 6;
    rotationAnimation2.cumulative = YES;
    rotationAnimation2.repeatCount = 10;
    [_loadingView2.layer addAnimation:rotationAnimation2 forKey:@"rotationAnimation"];//开始动画
    [_loadingView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.lightImageView.mas_centerX);
        make.centerY.equalTo(self.lightImageView.mas_centerY);
        make.width.and.height.equalTo(@170);
    }];
    
    // 3、菩萨
    self.pusaImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gy_释迦牟尼佛"]];
    self.pusaImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.pusaImageView];
    [self.pusaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.lightImageView.mas_centerY).offset(-20);
        make.width.equalTo(@(270*CKproportion));
        make.bottom.equalTo(self.view.mas_centerY);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        ChangePusaViewController *change = [ChangePusaViewController new];
        RootNavgationController *rooNav = [[RootNavgationController alloc]initWithRootViewController:change];
        [self presentViewController:rooNav animated:YES completion:^{
            
        }];
    }];
    [self.pusaImageView addGestureRecognizer:tap];
    
    // 4、
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
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
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
