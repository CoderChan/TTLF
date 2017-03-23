//
//  LiFoViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/1/20.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "LiFoViewController.h"
#import <Masonry.h>
#import "RootNavgationController.h"
#import "PusaShowView.h"


@interface LiFoViewController ()<PusaShowViewDelegate>

/** 菩萨图 */
@property (strong,nonatomic) UIImageView *pusaImageView;
/** 太阳光圈 */
@property (strong,nonatomic) UIImageView *sunImageView;
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


/** 佛像数组 */
@property (copy,nonatomic) NSArray *pusaArray;



@end

@implementation LiFoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    
//    [[TTLFManager sharedManager].networkManager getLifoInfoSuccess:^{
//        self.lightImageView.hidden = YES;
//        self.sunImageView.hidden = YES;
//    } Fail:^(NSString *errorMsg) {
//        [MBProgressHUD showError:errorMsg];
//    }];
    
    [[TTLFManager sharedManager].networkManager getPusaListSuccess:^(NSArray *array) {
        self.pusaArray = array;
    } Fail:^(NSString *errorMsg) {
        [self sendAlertAction:errorMsg];
    }];
    
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
    self.sunImageView = [[UIImageView alloc]init];
    self.sunImageView.image = [UIImage imageNamed:@"gy_lifo_light_02"];
    [self.view addSubview:self.sunImageView];
    [self.sunImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.lightImageView.mas_centerX);
        make.centerY.equalTo(self.lightImageView.mas_centerY);
        make.width.and.height.equalTo(@170);
    }];
    [self.sunImageView.layer addAnimation:[self AlphaLight:0.8] forKey:@"aAlpha"];
    
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
    UITapGestureRecognizer *tapPusa = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        PusaShowView *showView = [[PusaShowView alloc]initWithFrame:self.view.bounds];
        showView.array = self.pusaArray;
        showView.delegate = self;
        [self.view addSubview:showView];
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
    UITapGestureRecognizer *tapFlower = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self sendAlertAction:@"选择花瓶"];
    }];
    [self.leftFlowerV addGestureRecognizer:tapFlower];
    
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
    
    [self.rightFloerV addGestureRecognizer:tapFlower];
    
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
    self.leftFruitV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gy_橙子"]];
    self.leftFruitV.userInteractionEnabled = YES;
    [self.view addSubview:self.leftFruitV];
    [self.leftFruitV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.teaCupImgV.mas_centerY).offset(fruitTop);
        make.centerX.equalTo(self.leftFlowerV.mas_centerX);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    UITapGestureRecognizer *tapFruit = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self sendAlertAction:@"选择果盘"];
    }];
    [self.leftFruitV addGestureRecognizer:tapFruit];
    
    
    // 9、右侧果盘
    self.rightFruitV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gy_橙子"]];
    self.rightFruitV.userInteractionEnabled = YES;
    [self.view addSubview:self.rightFruitV];
    [self.rightFruitV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.teaCupImgV.mas_centerY).offset(fruitTop);
        make.centerX.equalTo(self.rightFloerV.mas_centerX);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    [self.rightFruitV addGestureRecognizer:tapFruit];
    
    // 10、佛牌
    
    CGFloat Fwidth = 40*CKproportion;
    CGFloat Fheight = 80*CKproportion;
    CGFloat Y = SCREEN_HEIGHT - 33 - Fheight;
    CGFloat X1 = (SCREEN_WIDTH - Fwidth * 3) / 4;
    CGFloat X2 = SCREEN_WIDTH/2 - Fwidth/2;
    CGFloat X3 = SCREEN_WIDTH - X1 - Fwidth;
    
    
    self.fopaiImgV1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chanxiu"]];
    self.fopaiImgV1.userInteractionEnabled = YES;
    self.fopaiImgV1.frame = CGRectMake(X1, Y, Fwidth, Fheight);
    [self.view addSubview:self.fopaiImgV1];
    
    self.fopaiImgV2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chanxiu"]];
    self.fopaiImgV2.userInteractionEnabled = YES;
    self.fopaiImgV2.frame = CGRectMake(X2, Y, Fwidth, Fheight);
    [self.view addSubview:self.fopaiImgV2];
    
    self.fopaiImgV3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chanxiu"]];
    self.fopaiImgV3.userInteractionEnabled = YES;
    self.fopaiImgV3.frame = CGRectMake(X3, Y, Fwidth, Fheight);
    [self.view addSubview:self.fopaiImgV3];
    
    UITapGestureRecognizer *tapFopai = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self sendAlertAction:@"选择佛牌"];
    }];
    
    [self.fopaiImgV1 addGestureRecognizer:tapFopai];
    [self.fopaiImgV2 addGestureRecognizer:tapFopai];
    [self.fopaiImgV3 addGestureRecognizer:tapFopai];
    
}

#pragma mark - 选中组件的代理方法
// 选中佛像
- (void)pusaDidSelectFoxiangModel:(FoxiangModel *)foxiangModel
{
    [self.pusaImageView sd_setImageWithURL:[NSURL URLWithString:foxiangModel.fa_xiang] placeholderImage:[UIImage imageNamed:@"gy_释迦牟尼佛"]];
}
// 选中花瓶


#pragma mark - 其他方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self beginLightingAction];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
    [self beginLightingAction];
    
}
- (void)beginLightingAction
{
    // 继续发光
    [self.lightImageView.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];//开始动画
    // 太阳光圈扩散
    
    
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
