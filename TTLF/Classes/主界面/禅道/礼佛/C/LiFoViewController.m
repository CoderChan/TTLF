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
#import "FopaiShowView.h"
#import "DecorationListView.h"


@interface LiFoViewController ()<PusaShowViewDelegate,FopaiViewDelegate,DecorationListViewDelegate>

/** 菩萨图 */
@property (strong,nonatomic) UIImageView *pusaImageView;
/** 太阳光圈 */
@property (strong,nonatomic) UIImageView *sunImageView;
/** 发光图1 */
@property (strong,nonatomic) UIImageView *lightImageView1;
/** 发光动画1 */
@property (strong,nonatomic) CABasicAnimation *rotationAnimation1;
/** 发光图2 */
@property (strong,nonatomic) UIImageView *lightImageView2;
/** 发光动画2 */
@property (strong,nonatomic) CABasicAnimation *rotationAnimation2;


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
/** 花瓶数组 */
@property (copy,nonatomic) NSArray *flowerArray;
/** 供香数组 */
@property (copy,nonatomic) NSArray *xiangArray;
/** 果盘数组 */
@property (copy,nonatomic) NSArray *fruitArray;
/** 佛牌数组 */
@property (copy,nonatomic) NSArray *fopaiArray;


@end

@implementation LiFoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"天天礼佛";
    [self setupSubViews];
    
    [[TTLFManager sharedManager].networkManager getLifoInfoSuccess:^(TodayLifoInfoModel *lifoModel) {
        if (lifoModel.pusa) {
            self.lightImageView1.hidden = NO;
            self.lightImageView2.hidden = NO;
            self.sunImageView.hidden = NO;
            [self.pusaImageView sd_setImageWithURL:[NSURL URLWithString:lifoModel.pusa] placeholderImage:[UIImage imageNamed:@"lifo_no_pusa"]];
//            self.pusaImageView.image = [UIImage imageNamed:@"gy"];
        }else{
            self.pusaImageView.image = [UIImage imageNamed:@"gy_lifo_god_none"];
            self.lightImageView1.hidden = YES;
            self.lightImageView2.hidden = YES;
            self.sunImageView.hidden = YES;
        }
        [self.xiangImgV sd_setImageWithURL:[NSURL URLWithString:lifoModel.xiang] placeholderImage:[UIImage imageNamed:@"gy_lifo_burner"]];
        [self.leftFlowerV sd_setImageWithURL:[NSURL URLWithString:lifoModel.flower] placeholderImage:[UIImage imageNamed:@"lifo_flower_place"]];
        [self.rightFloerV sd_setImageWithURL:[NSURL URLWithString:lifoModel.flower] placeholderImage:[UIImage imageNamed:@"lifo_flower_place"]];
        [self.leftFruitV sd_setImageWithURL:[NSURL URLWithString:lifoModel.fruit] placeholderImage:[UIImage imageNamed:@"gy_lifo_tray"]];
        [self.rightFruitV sd_setImageWithURL:[NSURL URLWithString:lifoModel.fruit] placeholderImage:[UIImage imageNamed:@"gy_lifo_tray"]];
        [self.fopaiImgV1 sd_setImageWithURL:[NSURL URLWithString:lifoModel.fopai] placeholderImage:[UIImage imageNamed:@"chanxiu"]];
        [self.fopaiImgV2 sd_setImageWithURL:[NSURL URLWithString:lifoModel.fopai] placeholderImage:[UIImage imageNamed:@"chanxiu"]];
        [self.fopaiImgV3 sd_setImageWithURL:[NSURL URLWithString:lifoModel.fopai] placeholderImage:[UIImage imageNamed:@"chanxiu"]];
        
    } Fail:^(NSString *errorMsg) {
        [MBProgressHUD showError:errorMsg];
    }];
    
    
    // 请求图片资源数组
    [[TTLFManager sharedManager].networkManager getLifoResourceSuccess:^(LifoResourceModel *lifoModel) {
        // 佛像数组随机排序
        self.pusaArray = lifoModel.pusa;
        self.xiangArray = lifoModel.xiang;
        self.flowerArray = lifoModel.flowers;
        self.fruitArray = lifoModel.furit;
        self.fopaiArray = lifoModel.pai;
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
    self.lightImageView1 = [[UIImageView alloc]init];
    self.lightImageView1.image = [UIImage imageNamed:@"gy_lifo_light_01"];
    [self.view addSubview:self.lightImageView1];
    self.rotationAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    self.rotationAnimation1.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    self.rotationAnimation1.duration = 6;
    self.rotationAnimation1.cumulative = YES;
    self.rotationAnimation1.repeatCount = 100000;
    [self.lightImageView1.layer addAnimation:self.rotationAnimation1 forKey:@"rotationAnimation"];//开始动画
    [self.lightImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(-3);
        make.top.equalTo(self.view.mas_top);
        make.width.and.height.equalTo(@180);
    }];
    self.lightImageView1.hidden = YES;
    
    self.lightImageView2 = [[UIImageView alloc]init];
    self.lightImageView2.image = [UIImage imageNamed:@"gy_lifo_light_01"];
    [self.view addSubview:self.lightImageView2];
    self.rotationAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    self.rotationAnimation2.toValue = [NSNumber numberWithFloat: -M_PI * 2.0];
    self.rotationAnimation2.duration = 6;
    self.rotationAnimation2.cumulative = YES;
    self.rotationAnimation2.repeatCount = 100000;
    [self.lightImageView2.layer addAnimation:self.rotationAnimation2 forKey:@"rotationAnimation"];//开始动画
    [self.lightImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(-3);
        make.top.equalTo(self.view.mas_top);
        make.width.and.height.equalTo(@180);
    }];
    self.lightImageView2.hidden = YES;
    
    // 太阳
    self.sunImageView = [[UIImageView alloc]init];
    self.sunImageView.image = [UIImage imageNamed:@"gy_lifo_light_02"];
    [self.view addSubview:self.sunImageView];
    [self.sunImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.lightImageView1.mas_centerX);
        make.centerY.equalTo(self.lightImageView1.mas_centerY);
        make.width.and.height.equalTo(@170);
    }];
    [self.sunImageView.layer addAnimation:[self AlphaLight:0.8] forKey:@"aAlpha"];
    self.sunImageView.hidden = YES;
    
    // 3、菩萨
    self.pusaImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gy_lifo_god_none"]];
    self.pusaImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.pusaImageView];
    [self.pusaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.lightImageView1.mas_centerY).offset(-20);
        make.width.equalTo(@(270*CKproportion));
        make.bottom.equalTo(self.view.mas_centerY);
    }];
    UITapGestureRecognizer *tapPusa = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.pusaArray.count >= 1) {
            PusaShowView *showView = [[PusaShowView alloc]initWithFrame:self.view.bounds];
            showView.array = [self randomizedArrayWithArray:self.pusaArray];
            showView.delegate = self;
            [self.view addSubview:showView];
        }
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
        
        if (self.xiangArray.count >= 1) {
            DecorationListView *decorationView = [[DecorationListView alloc]initWithFrame:self.view.bounds];
            decorationView.delegate = self;
            decorationView.decorationType = XiangType;
            decorationView.array = self.xiangArray;
            [self.view addSubview:decorationView];
        }
        
    }];
    [self.xiangImgV addGestureRecognizer:tapXiang];
    
    // 5、左侧花瓶
    self.leftFlowerV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lifo_flower_place"]];
    self.leftFlowerV.userInteractionEnabled = YES;
    [self.view addSubview:self.leftFlowerV];
    [self.leftFlowerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pusaImageView.mas_bottom);
        make.right.equalTo(self.xiangImgV.mas_left).offset(-22*CKproportion);
        make.width.equalTo(@90);
        make.height.equalTo(@150);
    }];
    UITapGestureRecognizer *tapFlower1 = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        
        if (self.flowerArray.count >= 1) {
            DecorationListView *decorationView = [[DecorationListView alloc]initWithFrame:self.view.bounds];
            decorationView.delegate = self;
            decorationView.decorationType = FlowerType;
            decorationView.array = self.flowerArray;
            [self.view addSubview:decorationView];
        }
        
    }];
    [self.leftFlowerV addGestureRecognizer:tapFlower1];
    
    // 6、右侧花瓶
    self.rightFloerV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lifo_flower_place"]];
    self.rightFloerV.userInteractionEnabled = YES;
    [self.view addSubview:self.rightFloerV];
    [self.rightFloerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pusaImageView.mas_bottom);
        make.left.equalTo(self.xiangImgV.mas_right).offset(22*CKproportion);
        make.width.equalTo(@90);
        make.height.equalTo(@150);
    }];
    
    UITapGestureRecognizer *tapFlower2 = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        
        if (self.flowerArray.count >= 1) {
            DecorationListView *decorationView = [[DecorationListView alloc]initWithFrame:self.view.bounds];
            decorationView.delegate = self;
            decorationView.decorationType = FlowerType;
            decorationView.array = self.flowerArray;
            [self.view addSubview:decorationView];
        }
        
    }];
    [self.rightFloerV addGestureRecognizer:tapFlower2];
    
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
    self.leftFruitV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gy_lifo_tray"]];
    self.leftFruitV.userInteractionEnabled = YES;
    [self.view addSubview:self.leftFruitV];
    [self.leftFruitV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.teaCupImgV.mas_centerY).offset(fruitTop);
        make.centerX.equalTo(self.leftFlowerV.mas_centerX);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    UITapGestureRecognizer *tapFruit1 = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        
        if (self.fruitArray.count >= 1) {
            DecorationListView *decorationView = [[DecorationListView alloc]initWithFrame:self.view.bounds];
            decorationView.delegate = self;
            decorationView.decorationType = FruitType;
            decorationView.array = self.fruitArray;
            [self.view addSubview:decorationView];
        }
        
    }];
    [self.leftFruitV addGestureRecognizer:tapFruit1];
    
    
    // 9、右侧果盘
    self.rightFruitV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gy_lifo_tray"]];
    self.rightFruitV.userInteractionEnabled = YES;
    [self.view addSubview:self.rightFruitV];
    [self.rightFruitV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.teaCupImgV.mas_centerY).offset(fruitTop);
        make.centerX.equalTo(self.rightFloerV.mas_centerX);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    
    UITapGestureRecognizer *tapFruit2 = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        
        if (self.fruitArray.count >= 1) {
            DecorationListView *decorationView = [[DecorationListView alloc]initWithFrame:self.view.bounds];
            decorationView.delegate = self;
            decorationView.decorationType = FruitType;
            decorationView.array = self.fruitArray;
            [self.view addSubview:decorationView];
        }
        
    }];
    [self.rightFruitV addGestureRecognizer:tapFruit2];
    
    // 10、佛牌
    
    CGFloat Fwidth = 40*CKproportion;
    CGFloat Fheight = 80*CKproportion;
    CGFloat Y = SCREEN_HEIGHT - 33 - Fheight;
    CGFloat X1 = (SCREEN_WIDTH - Fwidth * 3) / 4;
    CGFloat X2 = SCREEN_WIDTH/2 - Fwidth/2;
    CGFloat X3 = SCREEN_WIDTH - X1 - Fwidth;
    
    
    self.fopaiImgV1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chanxiu"]];
    self.fopaiImgV1.tag = 1;
    self.fopaiImgV1.userInteractionEnabled = YES;
    self.fopaiImgV1.frame = CGRectMake(X1, Y, Fwidth, Fheight);
    [self.view addSubview:self.fopaiImgV1];
    UITapGestureRecognizer *paiTap1 = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        FopaiShowView *fopaiView = [[FopaiShowView alloc]initWithFrame:self.view.bounds];
        fopaiView.delegate = self;
        fopaiView.array = self.fopaiArray;
        [self.view addSubview:fopaiView];
    }];
    [self.fopaiImgV1 addGestureRecognizer:paiTap1];
    
    self.fopaiImgV2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chanxiu"]];
    self.fopaiImgV2.tag = 2;
    self.fopaiImgV2.userInteractionEnabled = YES;
    self.fopaiImgV2.frame = CGRectMake(X2, Y, Fwidth, Fheight);
    [self.view addSubview:self.fopaiImgV2];
    UITapGestureRecognizer *paiTap2 = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        FopaiShowView *fopaiView = [[FopaiShowView alloc]initWithFrame:self.view.bounds];
        fopaiView.delegate = self;
        fopaiView.array = self.fopaiArray;
        [self.view addSubview:fopaiView];
    }];
    [self.fopaiImgV2 addGestureRecognizer:paiTap2];
    
    self.fopaiImgV3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chanxiu"]];
    self.fopaiImgV3.tag = 3;
    self.fopaiImgV3.userInteractionEnabled = YES;
    self.fopaiImgV3.frame = CGRectMake(X3, Y, Fwidth, Fheight);
    [self.view addSubview:self.fopaiImgV3];
    UITapGestureRecognizer *paiTap3 = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        FopaiShowView *fopaiView = [[FopaiShowView alloc]initWithFrame:self.view.bounds];
        fopaiView.delegate = self;
        fopaiView.array = self.fopaiArray;
        [self.view addSubview:fopaiView];
    }];
    [self.fopaiImgV3 addGestureRecognizer:paiTap3];
    
    
}

#pragma mark - 选中组件的代理方法
// 选中佛像
- (void)pusaDidSelectFoxiangModel:(FoxiangModel *)foxiangModel
{
    self.lightImageView1.hidden = NO;
    self.lightImageView2.hidden = NO;
    self.sunImageView.hidden = NO;
    [self.pusaImageView sd_setImageWithURL:[NSURL URLWithString:foxiangModel.fa_xiang] placeholderImage:[UIImage imageNamed:@"lifo_no_pusa"]];
}
// 选中佛牌
- (void)fopaiDidSelectFopaiModel:(FopaiModel *)fopaiModel
{
    [self.fopaiImgV1 sd_setImageWithURL:[NSURL URLWithString:fopaiModel.fopai_img] placeholderImage:[UIImage imageNamed:@"chanxiu"]];
    [self.fopaiImgV2 sd_setImageWithURL:[NSURL URLWithString:fopaiModel.fopai_img] placeholderImage:[UIImage imageNamed:@"chanxiu"]];
    [self.fopaiImgV3 sd_setImageWithURL:[NSURL URLWithString:fopaiModel.fopai_img] placeholderImage:[UIImage imageNamed:@"chanxiu"]];
    
}
// 选中花瓶、香、果盘
- (void)decorationListViewWithType:(DecorationType)decorationType SelectModel:(id)selectModel
{
    NSLog(@"decorationType = %ld,selectModel = %@",(long)decorationType,selectModel);
    if (decorationType == FlowerType) {
        // 花瓶
        FlowerVaseModel *flowerModel = selectModel;
        [self.leftFlowerV sd_setImageWithURL:[NSURL URLWithString:flowerModel.flower_img] placeholderImage:[UIImage imageNamed:@"lifo_flower_place"]];
        [self.rightFloerV sd_setImageWithURL:[NSURL URLWithString:flowerModel.flower_img] placeholderImage:[UIImage imageNamed:@"lifo_flower_place"]];
    }else if (decorationType == XiangType){
        // 贡香
        XiangModel *xiangModel = selectModel;
        [self.xiangImgV sd_setImageWithURL:[NSURL URLWithString:xiangModel.xiang_img] placeholderImage:[UIImage imageNamed:@"gy_lifo_burner"]];
    }else if (decorationType == FruitType){
        // 果盘
        FruitBowlModel *fruitModel = selectModel;
        [self.leftFruitV sd_setImageWithURL:[NSURL URLWithString:fruitModel.fruit_img] placeholderImage:[UIImage imageNamed:@"gy_lifo_tray"]];
        [self.rightFruitV sd_setImageWithURL:[NSURL URLWithString:fruitModel.fruit_img] placeholderImage:[UIImage imageNamed:@"gy_lifo_tray"]];
    }
}


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
    [self.lightImageView1.layer addAnimation:self.rotationAnimation1 forKey:@"rotationAnimation"];//开始动画
    [self.lightImageView2.layer addAnimation:self.rotationAnimation2 forKey:@"rotationAnimation"];
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
