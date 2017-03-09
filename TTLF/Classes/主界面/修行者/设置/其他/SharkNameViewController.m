//
//  SharkNameViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/1/9.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SharkNameViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>
#import <MJExtension/MJExtension.h>

@interface SharkNameViewController ()


/** 播放类 */
@property (strong,nonatomic) AVAudioPlayer *player;
/** 花名 */
@property (strong,nonatomic) UILabel *nameLabel;

/** 花名列表 */
@property (copy,nonatomic) NSArray *array;
/** 中心图片 */
@property (strong,nonatomic) UIImageView *imageV;
/** 爆炸效果 */
@property (strong,nonatomic) CAEmitterLayer *emitter;
/** 是否允许摇动 */
@property (assign,nonatomic) BOOL isShake;
/** 选中的索引 */
@property (assign,nonatomic) int selectIconIndex;
/** 菊花 */
@property (strong,nonatomic) UIActivityIndicatorView *indicatorV;
/** 保留原花名 */
@property (strong,nonatomic) UIButton *oldButton;
/** 使用新花名 */
@property (strong,nonatomic) UIButton *userNewButton;

@end

@implementation SharkNameViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"摇一摇花名";
    self.view.backgroundColor = NavColor;
    
    [self startAction];
    
}

- (void)startAction
{
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.indicatorV];
    
    [self.indicatorV startAnimating];
    [[TTLFManager sharedManager].networkManager sharkActionSuccess:^(NSArray *array) {
        [self.indicatorV stopAnimating];
        self.array = array;
        [self setupSubViews];
    } Fail:^(NSString *errorMsg) {
        [self.indicatorV stopAnimating];
        [MBProgressHUD showError:errorMsg];
    }];
}
- (void)setupSubViews
{
    
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    self.isShake = [UIApplication sharedApplication].applicationSupportsShakeToEdit;
    [self becomeFirstResponder];
    
    // 图标
    self.imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yaoyiyao"]];
    [self.view addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-25);
        make.width.and.height.equalTo(@120);
    }];
    
    
    // 保留原花名
    self.oldButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.oldButton.backgroundColor = RGBACOLOR(37, 49, 93, 1);
    __weak SharkNameViewController *copySelf = self;
    [self.oldButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [copySelf.navigationController popViewControllerAnimated:YES];
    }];
    [self.oldButton setTitle:@"保留原花名" forState:UIControlStateNormal];
    [self.oldButton setTitleColor:RGBACOLOR(38, 203, 114, 1) forState:UIControlStateNormal];
    self.oldButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.oldButton];
    [self.oldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH/2 - 0.5));
        make.height.equalTo(@44);
    }];
    [self.oldButton setHidden:YES];
    
    // 使用新花名
    self.userNewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.userNewButton.backgroundColor = RGBACOLOR(37, 49, 93, 1);
    
    [self.userNewButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [copySelf.indicatorV startAnimating];
        [[TTLFManager sharedManager].networkManager updateStageInfo:copySelf.array[copySelf.selectIconIndex] Success:^{
            [copySelf.indicatorV stopAnimating];
            [copySelf.navigationController popViewControllerAnimated:YES];
        } Fail:^(NSString *errorMsg) {
            [copySelf.indicatorV stopAnimating];
            [MBProgressHUD showError:errorMsg];
        }];
    }];
    [self.userNewButton setTitle:@"使用新花名" forState:UIControlStateNormal];
    [self.userNewButton setTitleColor:RGBACOLOR(38, 203, 114, 1) forState:UIControlStateNormal];
    self.userNewButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.userNewButton];
    [self.userNewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH/2 - 0.5));
        make.height.equalTo(@44);
    }];
     
    [self.userNewButton setHidden:YES];
    
}

#pragma mark - 开始摇动
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    [self namedUI];
    
    self.oldButton.hidden = YES;
    self.userNewButton.hidden = YES;
    
    if (_isShake) {
        [self boomAnimation];
        // 欲播放
        [self.player prepareToPlay];
        
        [self.player play];
        
        self.isShake = NO;
    }
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"摇动结束");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.player stop];
        // 显示两个按钮
        
        self.oldButton.hidden = NO;
        self.userNewButton.hidden = NO;
        
    });
}

- (void)boomAnimation
{
    //  CAEmitterLayer -- 粒子容器
    self.emitter = [CAEmitterLayer layer];
    _emitter.frame = self.view.bounds;
    _emitter.emitterMode = kCAEmitterLayerSurface; // 发射模式
    _emitter.emitterShape = kCAEmitterLayerPoint; // 发射源模式
    [self.view.layer addSublayer:_emitter];
    _emitter.renderMode = kCAEmitterLayerBackToFront;
    _emitter.emitterPosition = CGPointMake(_emitter.frame.size.width/2, _emitter.frame.size.height/2); // 动画中心点
    
    
    // 粒子描述
    CAEmitterCell *cell = [[CAEmitterCell alloc]init];
    cell.contents = (__bridge id _Nullable)([[UIImage imageNamed:[NSString stringWithFormat:@"%d",self.selectIconIndex]] CGImage]);
    cell.birthRate = 100; // 爆炸多少个
    cell.lifetime = 3; // 粒子生命周期
    cell.alphaSpeed = -0.4;
    cell.velocity = 50;
    cell.velocityRange = 150;
    cell.emissionRange = M_PI * 2.0;
    
    _emitter.emitterCells = @[cell];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.emitter removeFromSuperlayer];
        self.isShake = YES;
    });
}


#pragma mark - 花名改变之后要做的事情
- (void)namedUI
{
    
    NSInteger count = self.array.count;
    self.selectIconIndex = arc4random() % count;
    StageModel *stageModel = self.array[self.selectIconIndex];
    self.nameLabel.text = stageModel.stage_name;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:stageModel.stage_img] placeholderImage:[UIImage imageNamed:@"1"]];
    
    
}
#pragma mark - 取消摇动
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.player stop];
    });
}

- (AVAudioPlayer *)player
{
    if (!_player) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"shark" ofType:@"mp3"];
        NSURL *url = [[NSURL alloc]initFileURLWithPath:path];
        NSError *error;
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        if (error) {
            NSLog(@"error = %@",error.localizedDescription);
        }
        
        // 设置音乐播放次数  -1是一直循环
        _player.numberOfLoops = 1;
        
    }
    return _player;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.imageV.mas_bottom);
            make.height.equalTo(@21);
        }];
    }
    return _nameLabel;
}

- (UIActivityIndicatorView *)indicatorV
{
    if (!_indicatorV) {
        _indicatorV = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 21, 30, 30)];
        _indicatorV.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    return _indicatorV;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 去掉那条线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // 恢复那条线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefaultPrompt];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

@end
