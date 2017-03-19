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
/** 佛牌1 */
@property (strong,nonatomic) UIImageView *fopaiImgV1;
/** 佛牌1 */
@property (strong,nonatomic) UIImageView *fopaiImgV2;
/** 佛牌1 */
@property (strong,nonatomic) UIImageView *fopaiImgV3;


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
        make.top.equalTo(self.pusaImageView.mas_bottom);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    UITapGestureRecognizer *tapXiang = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        
        self.xiangImgV.image = [UIImage imageNamed:@"gy_智慧香"];
        
    }];
    [self.xiangImgV addGestureRecognizer:tapXiang];
    
    // 5、左侧花瓶
    self.leftFlowerV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gy_曼陀罗花"]];
    self.leftFlowerV.userInteractionEnabled = YES;
    [self.view addSubview:self.leftFlowerV];
    [self.leftFlowerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pusaImageView.mas_bottom);
        make.right.equalTo(self.xiangImgV.mas_left).offset(-22*CKproportion);
        make.width.equalTo(@90);
        make.height.equalTo(@150);
    }];
    
    // 6、右侧花瓶
    self.rightFloerV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gy_曼陀罗花"]];
    self.rightFloerV.userInteractionEnabled = YES;
    [self.view addSubview:self.rightFloerV];
    [self.rightFloerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pusaImageView.mas_bottom);
        make.left.equalTo(self.xiangImgV.mas_right).offset(22*CKproportion);
        make.width.equalTo(@90);
        make.height.equalTo(@150);
    }];
    
    CGFloat teaCupTop; // 茶杯距上距离
    CGFloat fruitTop; // 果盘距上距离
    if (SCREEN_WIDTH < 370) {
        // 3.5寸和4.0寸的手机
        teaCupTop = -25*CKproportion;
        fruitTop = -12*CKproportion;
    }else{
        // 4.7寸以上
        teaCupTop = -8*CKproportion;
        fruitTop = -3;
    }
    
    // 7、茶杯
    self.teaCupImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gy_lifo_bigCup"]];
    [self.view addSubview:self.teaCupImgV];
    [self.teaCupImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.xiangImgV.mas_bottom).offset(teaCupTop);
        make.width.and.height.equalTo(@80);
    }];
    
    // 8、左侧果盘
    self.leftFruitV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gy_荔枝"]];
    self.leftFruitV.userInteractionEnabled = YES;
    [self.view addSubview:self.leftFruitV];
    [self.leftFruitV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.teaCupImgV.mas_centerY).offset(fruitTop);
        make.centerX.equalTo(self.leftFlowerV.mas_centerX);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    
    // 9、右侧果盘
    self.rightFruitV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gy_荔枝"]];
    self.rightFruitV.userInteractionEnabled = YES;
    [self.view addSubview:self.rightFruitV];
    [self.rightFruitV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.teaCupImgV.mas_centerY).offset(fruitTop);
        make.centerX.equalTo(self.rightFloerV.mas_centerX);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    
    // 10、佛牌
    CGFloat Fwidth = 40*CKproportion;
    CGFloat Fheight = 80*CKproportion;
    CGFloat Y = SCREEN_HEIGHT - 33 - Fheight;
    CGFloat X1 = (SCREEN_WIDTH - Fwidth * 3) / 4;
    CGFloat X2 = SCREEN_WIDTH/2 - Fwidth/2;
    CGFloat X3 = SCREEN_WIDTH - X1 - Fwidth;
    
    
    self.fopaiImgV1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chanxiu"]];
    self.fopaiImgV1.frame = CGRectMake(X1, Y, Fwidth, Fheight);
    [self.view addSubview:self.fopaiImgV1];
    
    self.fopaiImgV2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chanxiu"]];
    self.fopaiImgV2.frame = CGRectMake(X2, Y, Fwidth, Fheight);
    [self.view addSubview:self.fopaiImgV2];
    
    self.fopaiImgV3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chanxiu"]];
    self.fopaiImgV3.frame = CGRectMake(X3, Y, Fwidth, Fheight);
    [self.view addSubview:self.fopaiImgV3];
    
    
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
