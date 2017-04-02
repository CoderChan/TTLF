//
//  MusicPlayingController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/2.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MusicPlayingController.h"
#import <Masonry.h>

@interface MusicPlayingController ()

/** 进度条 */
@property (strong,nonatomic) UISlider *slider;
/** 进度时间 */
@property (strong,nonatomic) UILabel *startTime;
/** 总时间 */
@property (strong,nonatomic) UILabel *endTime;


@end

@implementation MusicPlayingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"大悲咒";
    [self setupSubViews];
}

- (void)setupSubViews
{
    NSString *circleName;
    if (SCREEN_WIDTH == 375) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cm2_fm_bg_ip6"]];
        circleName = @"music_circle_ip6";
    }else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cm2_fm_bg"]];
        circleName = @"music_circle";
    }
    
    // 伪造导航栏
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    navView.userInteractionEnabled = YES;
    navView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:navView];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width/2 - 60, 24, 120, 30)];
    titleLabel.text = self.title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    // 线
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    xian.frame = CGRectMake(0, 63, self.view.width, 1);
    [navView addSubview:xian];
    
    // 左侧返回键
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    leftButton.frame = CGRectMake(5, 24, 38, 38);
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [navView addSubview:leftButton];
    
    // 右边分享键
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"right_share"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setFrame:CGRectMake(self.view.width - 8 - 38, 24, 38, 38)];
    [navView addSubview:rightButton];
    
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:circleName]];
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(120*CKproportion);
        make.width.and.height.equalTo(@(SCREEN_WIDTH * 0.7));
    }];
    
    CGFloat space = (SCREEN_WIDTH - 48 * 5)/6;
    
    //    播放按钮
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:[UIImage imageNamed:@"music_btn_play_prs"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"music_btn_play_prs"] forState:UIControlStateHighlighted];
    [self.view addSubview:playBtn];
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.width.and.height.equalTo(@48);
    }];
    
    //    上一首
    UIButton *lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lastBtn setImage:[UIImage imageNamed:@"music_btn_last_prs"] forState:UIControlStateNormal];
    [lastBtn setImage:[UIImage imageNamed:@"music_btn_last_prs"] forState:UIControlStateHighlighted];
    [self.view addSubview:lastBtn];
    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(playBtn.mas_left).offset(-space);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.width.and.height.equalTo(@48);
    }];
    
    // 下一首
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setImage:[UIImage imageNamed:@"music_btn_next_prs"] forState:UIControlStateNormal];
    [nextBtn setImage:[UIImage imageNamed:@"music_btn_next_prs"] forState:UIControlStateHighlighted];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(playBtn.mas_right).offset(space);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.width.and.height.equalTo(@48);
    }];
    
    // 歌单
    UIButton *listBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [listBtn setImage:[UIImage imageNamed:@"music_play_btn_list_prs"] forState:UIControlStateNormal];
    [listBtn setImage:[UIImage imageNamed:@"music_play_btn_list_prs"] forState:UIControlStateHighlighted];
    [self.view addSubview:listBtn];
    [listBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-space);
        make.centerY.equalTo(playBtn.mas_centerY);
        make.width.and.height.equalTo(@42);
    }];
    
    // 顺序
    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [orderBtn setImage:[UIImage imageNamed:@"music_play_btn_shuffle_prs"] forState:UIControlStateNormal];
    [orderBtn setImage:[UIImage imageNamed:@"music_play_btn_shuffle_prs"] forState:UIControlStateHighlighted];
    [self.view addSubview:orderBtn];
    [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(space);
        make.centerY.equalTo(playBtn.mas_centerY);
        make.width.and.height.equalTo(@42);
    }];
    
    // 进度条
    self.slider = [[UISlider alloc]init];
    self.slider.minimumValue = 0.f;
    self.slider.maximumValue = 2.35f;
    [self.slider setThumbImage:[UIImage imageNamed:@"music_dian"] forState:UIControlStateNormal];
    [self.view addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(playBtn.mas_top).offset(-5);
        make.left.equalTo(self.view.mas_left).offset(40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@20);
    }];
    // 开始时间
    self.startTime = [[UILabel alloc]init];
    self.startTime.text = @"00:00";
    self.startTime.font = [UIFont systemFontOfSize:8];
    self.startTime.textAlignment = NSTextAlignmentCenter;
    self.startTime.textColor = [UIColor lightGrayColor];
    [self.view addSubview:self.startTime];
    [self.startTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.slider.mas_centerY);
        make.right.equalTo(self.slider.mas_left);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(@20);
    }];
    
    // 开始时间
    self.endTime = [[UILabel alloc]init];
    self.endTime.text = @"23:48";
    self.endTime.font = [UIFont systemFontOfSize:8];
    self.endTime.textAlignment = NSTextAlignmentCenter;
    self.endTime.textColor = [UIColor lightGrayColor];
    [self.view addSubview:self.endTime];
    [self.endTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.slider.mas_centerY);
        make.left.equalTo(self.slider.mas_right);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@20);
    }];

}

- (void)shareAction
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


@end
