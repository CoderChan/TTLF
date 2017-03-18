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
/** 发光动画 */
@property (strong,nonatomic) CABasicAnimation *rotationAnimation;
/** 香坛子 */
@property (strong,nonatomic) UIImageView *xiangImgV;
/** 左侧花瓶 */
@property (strong,nonatomic) UIImageView *leftFlowerV;
/** 右侧花瓶 */
@property (strong,nonatomic) UIImageView *rightFloerV;
/** 茶瓶 */
@property (strong,nonatomic) UIImageView *teaCupImgV;
/** 左侧果盘 */
@property (strong,nonatomic) UIImageView *leftFruitV;
/** 右侧果盘 */
@property (strong,nonatomic) UIImageView *rightFruitV;

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
    self.rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    self.rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    self.rotationAnimation.duration = 6;
    self.rotationAnimation.cumulative = YES;
    self.rotationAnimation.repeatCount = 100000;
    [self.lightImageView.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];//开始动画
    [self.lightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(-3);
        make.top.equalTo(self.view.mas_top);
        make.width.and.height.equalTo(@180);
    }];
    
    //    [self.lightImageView.layer removeAnimationForKey:@"rotationAnimation"]//结束动画
    
    // 太阳
    UIImageView *loadingView2 = [[UIImageView alloc]init];
    loadingView2.image = [UIImage imageNamed:@"gy_lifo_light_02"];
    [self.view addSubview:loadingView2];
    CABasicAnimation *rotationAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation2.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation2.duration = 6;
    rotationAnimation2.cumulative = YES;
    rotationAnimation2.repeatCount = 10;
    [loadingView2.layer addAnimation:rotationAnimation2 forKey:@"rotationAnimation"];//开始动画
    [loadingView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.lightImageView.mas_centerX);
        make.centerY.equalTo(self.lightImageView.mas_centerY);
        make.width.and.height.equalTo(@170);
    }];
    
    // 3、菩萨
    self.pusaImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gy_大日如来菩萨"]];
    self.pusaImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.pusaImageView];
    [self.pusaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.lightImageView.mas_centerY).offset(-20);
        make.width.equalTo(@(270*CKproportion));
        make.bottom.equalTo(self.view.mas_centerY);
    }];
    UITapGestureRecognizer *tapPusa = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        ChangePusaViewController *change = [ChangePusaViewController new];
        [self.navigationController pushViewController:change animated:YES];
    }];
    [self.pusaImageView addGestureRecognizer:tapPusa];
    
    // 4、香坛子 gy_lifo_burner
    self.xiangImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gy_lifo_burner"]];
    self.xiangImgV.userInteractionEnabled = YES;
    [self.view addSubview:self.xiangImgV];
    [self.xiangImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.pusaImageView.mas_bottom).offset(3);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    UITapGestureRecognizer *tapXiang = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        
        self.xiangImgV.image = [UIImage imageNamed:@"gy_智慧香"];
        
    }];
    [self.xiangImgV addGestureRecognizer:tapXiang];
    
    // 5、左侧花瓶
    self.leftFlowerV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hehua"]];
    self.leftFlowerV.userInteractionEnabled = YES;
    [self.view addSubview:self.leftFlowerV];
    [self.leftFlowerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.xiangImgV.mas_centerY).offset(-35);
        make.right.equalTo(self.xiangImgV.mas_left).offset(-25);
        make.width.equalTo(@90);
        make.height.equalTo(@150);
    }];
    
    // 6、右侧花瓶
    self.rightFloerV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hehua"]];
    self.rightFloerV.userInteractionEnabled = YES;
    [self.view addSubview:self.rightFloerV];
    [self.rightFloerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.xiangImgV.mas_centerY).offset(-35);
        make.left.equalTo(self.xiangImgV.mas_right).offset(25);
        make.width.equalTo(@90);
        make.height.equalTo(@150);
    }];
    
    // 7、茶杯
    self.teaCupImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gy_lifo_bigCup"]];
    [self.view addSubview:self.teaCupImgV];
    [self.teaCupImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.xiangImgV.mas_bottom).offset(-10);
        make.width.and.height.equalTo(@80);
    }];
    
    // 8、左侧果盘
    self.leftFruitV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gy_荔枝"]];
    self.leftFruitV.userInteractionEnabled = YES;
    [self.view addSubview:self.leftFruitV];
    [self.leftFruitV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.teaCupImgV.mas_centerY).offset(1);
        make.centerX.equalTo(self.leftFlowerV.mas_centerX);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    
    // 9、右侧果盘
    self.rightFruitV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gy_荔枝"]];
    self.rightFruitV.userInteractionEnabled = YES;
    [self.view addSubview:self.rightFruitV];
    [self.rightFruitV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.teaCupImgV.mas_centerY).offset(1);
        make.centerX.equalTo(self.rightFloerV.mas_centerX);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 继续发光
    [self.lightImageView.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];//开始动画
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
    // 继续发光
    [self.lightImageView.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];//开始动画
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
