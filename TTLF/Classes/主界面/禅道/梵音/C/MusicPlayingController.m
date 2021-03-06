//
//  MusicPlayingController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/6/25.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MusicPlayingController.h"
#import "ShareView.h"
#import "PlayListView.h"
#import <FSAudioController.h>
#import <FSAudioStream.h>
#import <FSPlaylistItem.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MusicDetialView.h"
#import "CommentMusicController.h"


@interface MusicPlayingController ()<ShareViewDelegate>
// 播放清单
@property (strong,nonatomic) NSArray *dataSource;
// 当前播放索引
@property (assign,nonatomic) NSInteger currentIndex;
// 封面背景图
@property (strong,nonatomic) UIImageView *circleImgView;
@property (strong,nonatomic) UIImageView *centerImgView;
// 背景旋转动画
@property (strong,nonatomic) CABasicAnimation *xuanzhuanAnimation;
// 标题
@property (strong,nonatomic) UILabel *titleLabel;
// 作者
@property (strong,nonatomic) UILabel *writerLabel;
// 播放按钮
@property (strong,nonatomic) UIButton *playButton;
// 上一首
@property (strong,nonatomic) UIButton *lastButton;
// 下一首
@property (strong,nonatomic) UIButton *nextButton;
// 播放顺序
@property (strong,nonatomic) UIButton *playTypeButton;

// 歌单按钮
@property (strong,nonatomic) UIButton *playListButton;
// 当前播放时间
@property (strong,nonatomic) UILabel *currentTimeLabel;
// 总时长
@property (strong,nonatomic) UILabel *sumTimeLabel;
// 进度条
@property (strong,nonatomic) UIProgressView *progressView;
// 进度条
@property (strong,nonatomic) UISlider *sliderView;

// 下载按钮
@property (strong,nonatomic) UIButton *downLoadButton;
// 评论按钮
@property (strong,nonatomic) UIButton *commentButton;
// 评论数据源
@property (copy,nonatomic) NSArray *commentArray;
// 评论数
@property (strong,nonatomic) UILabel *commentNumLabel;

@property (strong,nonatomic) NSMutableArray *playItemArray;


@end

@implementation MusicPlayingController

#pragma mark - 初始化
- (instancetype)initWithArray:(NSArray *)dataSource CurrentIndex:(NSInteger)currentIndex
{
    self = [super init];
    if (self) {
        
        self.dataSource = dataSource;
        self.currentIndex = currentIndex;
        
        for (int i = 0; i < self.dataSource.count; i++) {
            AlbumInfoModel *model = self.dataSource[i];
            FSPlaylistItem *item = [[FSPlaylistItem alloc]init];
            item.listID = i;
            item.title = model.music_name;
            item.url = [NSURL URLWithString:model.music_desc];
            item.originatingUrl = [NSURL URLWithString:model.music_desc];
            [self.playItemArray addObject:item];
        }
        
        [self.playItemArray sortUsingComparator:^NSComparisonResult(FSPlaylistItem  *obj1, FSPlaylistItem  *obj2) {
            NSString *musicID1 = [NSString stringWithFormat:@"%ld",obj1.listID];
            NSString *musicID2 = [NSString stringWithFormat:@"%ld",obj2.listID];;
            return [musicID1 localizedStandardCompare:musicID2];
        }];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    
}
#pragma mark - 绘制界面
- (void)setupSubViews
{
    AlbumInfoModel *model = self.dataSource[self.currentIndex];
    
    // 背景及左右按钮
    NSString *circleName;
    NSString *coverPlace;
    if (SCREEN_WIDTH == 375) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cm2_fm_bg_ip6"]];
        circleName = @"music_circle_ip6";
        coverPlace = @"cm2_default_cover_play_ip6";
    }else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cm2_fm_bg"]];
        circleName = @"music_circle";
        coverPlace = @"cm2_default_cover_play";
    }
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [dismissButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [dismissButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    dismissButton.frame = CGRectMake(8, 22, 38, 38);
    [self.view addSubview:dismissButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(SCREEN_WIDTH - 12 - 40, 21, 40, 40);
    [shareButton setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateHighlighted];
    [shareButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        ShareView *shareView = [[ShareView alloc]initWithFrame:keyWindow.bounds];
        shareView.delegate = self;
        [keyWindow addSubview:shareView];
    }];
    [self.view addSubview:shareButton];
    
    // 标题及作者
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(61 + 10, 21, self.view.width - 142, 21)];
    self.titleLabel.text = model.music_name;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    self.writerLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.x, CGRectGetMaxY(self.titleLabel.frame), self.titleLabel.width, 20)];
    self.writerLabel.text = model.music_author;
    self.writerLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.writerLabel.textColor = [UIColor whiteColor];
    self.writerLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.writerLabel];
    
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    xian.frame = CGRectMake(0, CGRectGetMaxY(self.writerLabel.frame) + 1, self.view.width, 1);
    [self.view addSubview:xian];
    
    
    // 标准 SQ
    UIImageView *biaozhunImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"player_btn_bz_sel_normal"]];
    biaozhunImgView.frame = CGRectMake(self.view.width/2 - 44 - 10, CGRectGetMaxY(xian.frame) + 45, 44, 20);
    [self.view addSubview:biaozhunImgView];
    
    UIImageView *sqImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"player_btn_sq_sel_normal"]];
    sqImgView.frame = CGRectMake(self.view.width/2 + 10, biaozhunImgView.y, biaozhunImgView.width, biaozhunImgView.height);
    [self.view addSubview:sqImgView];
    
    // 封面
    UIImageView *huanImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"music_circle_huan"]];
    huanImgView.userInteractionEnabled = YES;
    huanImgView.frame = CGRectMake(50, CGRectGetMaxY(biaozhunImgView.frame) + 35*CKproportion, self.view.width - 100, self.view.width - 100);
    [self.view addSubview:huanImgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDetialAction)];
    [huanImgView addGestureRecognizer:tap];
    
    self.circleImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:circleName]];
    self.circleImgView.frame = CGRectMake(10, 10, huanImgView.width - 20, huanImgView.height - 20);
    [huanImgView addSubview:self.circleImgView];
    
    
    self.xuanzhuanAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    self.xuanzhuanAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    self.xuanzhuanAnimation.duration = 10;
    self.xuanzhuanAnimation.speed = 0.2;
    self.xuanzhuanAnimation.cumulative = YES;
    self.xuanzhuanAnimation.repeatCount = 100000;
    [self.circleImgView.layer addAnimation:self.xuanzhuanAnimation forKey:@"rotationAnimation"];
    
    self.centerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, self.circleImgView.width - 30, self.circleImgView.height - 30)];
    self.centerImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.centerImgView setContentScaleFactor:[UIScreen mainScreen].scale];
    self.centerImgView.layer.masksToBounds = YES;
    self.centerImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight & UIViewAutoresizingFlexibleWidth;
    self.centerImgView.layer.cornerRadius = (self.circleImgView.width - 30)/2;
    [self.centerImgView sd_setImageWithURL:[NSURL URLWithString:model.music_logo] placeholderImage:[UIImage imageWithColor:MainColor]];
    [self.circleImgView addSubview:self.centerImgView];
    
    // 播放按钮
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setImage:[UIImage imageNamed:@"music_btn_play"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"music_btn_play_prs"] forState:UIControlStateHighlighted];
    self.playButton.frame = CGRectMake(self.view.width/2 - 34, self.view.height - 16 - 68, 68, 68);
    [self.playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playButton];
    
    CGFloat space = (self.view.width/2 - self.playButton.width/2 - 40 - 49)/3;
    
    // 播放模式
    self.playTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playTypeButton setImage:[UIImage imageNamed:@"cm2_icn_loop"] forState:UIControlStateNormal];
    [self.playTypeButton setImage:[UIImage imageNamed:@"cm2_icn_loop_prs"] forState:UIControlStateHighlighted];
    self.playTypeButton.frame = CGRectMake(space, self.playButton.y + 14, 40, 40);
    [self.playTypeButton addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playTypeButton];
    
    // 上一首按钮
    self.lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.lastButton setImage:[UIImage imageNamed:@"music_btn_last"] forState:UIControlStateNormal];
    [self.lastButton setImage:[UIImage imageNamed:@"music_btn_last_prs"] forState:UIControlStateHighlighted];
    self.lastButton.frame = CGRectMake(space*2 + self.playTypeButton.width, self.playButton.y + 9.5, 49, 49);
    [self.lastButton addTarget:self action:@selector(lastButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lastButton];
    
    // 播放列表
    self.playListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playListButton setImage:[UIImage imageNamed:@"cm2_icn_list"] forState:UIControlStateNormal];
    [self.playListButton setImage:[UIImage imageNamed:@"cm2_icn_list_prs"] forState:UIControlStateHighlighted];
    self.playListButton.frame = CGRectMake(self.playButton.x + self.playButton.width + space*2 + 49, self.playButton.y + 14, 40, 40);
    [self.playListButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playListButton];
    
    // 下一首
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextButton setImage:[UIImage imageNamed:@"music_btn_next"] forState:UIControlStateNormal];
    [self.nextButton setImage:[UIImage imageNamed:@"music_btn_next_prs"] forState:UIControlStateHighlighted];
    self.nextButton.frame = CGRectMake(self.playButton.x + self.playButton.width + space, self.playButton.y + 9.5, 49, 49);
    [self.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    
    // 当前播放时间
    self.currentTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.playButton.y - 21 - 15, 40, 21)];
    self.currentTimeLabel.text = @"0:00";
    self.currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.currentTimeLabel.textColor = [UIColor whiteColor];
    self.currentTimeLabel.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:self.currentTimeLabel];
    
    // 播放总时长
    self.sumTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width - self.currentTimeLabel.width, self.currentTimeLabel.y, self.currentTimeLabel.width, self.currentTimeLabel.height)];
    self.sumTimeLabel.text = @"0:00";
    self.sumTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.sumTimeLabel.textColor = [UIColor whiteColor];
    self.sumTimeLabel.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:self.sumTimeLabel];
    
    
    // 进度条
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.currentTimeLabel.frame) + 3, self.currentTimeLabel.y + (self.currentTimeLabel.height - 4)/2, self.view.width - self.currentTimeLabel.width*2 - 6, 4)];
    self.progressView.tintColor = MainColor;
    self.progressView.progress = 0.3;
    [self.view addSubview:self.progressView];
    
    // UISlider
    self.sliderView = [[UISlider alloc]initWithFrame:CGRectMake(self.progressView.x - 2, self.progressView.y - 14, self.progressView.width + 4, 30)];
    [self.sliderView addTarget:self action:@selector(sliderMoveAction:) forControlEvents:UIControlEventValueChanged];
    [self.sliderView setTintColor:MainColor];
    [self.sliderView setThumbImage:[UIImage imageNamed:@"music_slider"] forState:UIControlStateNormal];
    [self.sliderView setThumbImage:[UIImage imageNamed:@"music_slider"] forState:UIControlStateNormal];
    self.sliderView.value = 0;
    [self.view addSubview:self.sliderView];
    
    // 下载按钮
    self.downLoadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.downLoadButton setImage:[UIImage imageNamed:@"cm2_icn_dld_prs"] forState:UIControlStateNormal];
    [self.downLoadButton setImage:[UIImage imageNamed:@"cm2_icn_dld_prs"] forState:UIControlStateHighlighted];
    self.downLoadButton.frame = CGRectMake(self.lastButton.x, self.currentTimeLabel.y - 18 - 49, 49, 49);
    [self.downLoadButton addTarget:self action:@selector(downLoadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.downLoadButton];
    
    // 评论按钮
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentButton setImage:[UIImage imageNamed:@"cm2_fm_btn_cmt_number_prs"] forState:UIControlStateNormal];
    [self.commentButton setImage:[UIImage imageNamed:@"cm2_fm_btn_cmt_number_prs"] forState:UIControlStateHighlighted];
    self.commentButton.frame = CGRectMake(self.nextButton.x, self.downLoadButton.y, 49, 49);
    [self.commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.commentButton];
    
    // 评论数
    self.commentNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 3, 20, 20)];
    self.commentNumLabel.text = @"0";
    self.commentNumLabel.textAlignment = NSTextAlignmentLeft;
    self.commentNumLabel.textColor = [UIColor whiteColor];
    self.commentNumLabel.font = [UIFont systemFontOfSize:9];
    [self.commentButton addSubview:self.commentNumLabel];
    
    // 添加监听
    [YLNotificationCenter addObserver:self selector:@selector(beginLightingAction) name:UIApplicationDidBecomeActiveNotification object:nil];
    // 监听刚进来时的进度
    [YLNotificationCenter addObserver:self selector:@selector(observerDurationAction) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self observerDurationAction];
    
    // 判断播放状态
    FSPlaylistItem *currentStream = [[MusicPlayerManager sharedManager].fsController currentPlaylistItem];
    if ([[MusicPlayerManager sharedManager].fsController isPlaying]) {
        // 正在播放，判断是不是当前播放的mp3
        if ([model.music_desc isEqualToString:currentStream.url.absoluteString]) {
            // 播放的是同一首
            [self.playButton setImage:[UIImage imageNamed:@"music_btn_pause"] forState:UIControlStateNormal];
            [self.playButton setImage:[UIImage imageNamed:@"music_btn_pause_prs"] forState:UIControlStateHighlighted];
        }else{
            // 切换歌曲
            [self playButtonClick:self.playButton];
        }
    }else{
        // 没有播放
        [self playButtonClick:self.playButton];
    }
    
    // 获取评论数据数据
    self.commentArray = @[];
    [[TTLFManager sharedManager].networkManager musicCommentListWithModel:model Success:^(NSArray *array) {
        self.commentArray = array;
        if (array.count > 99) {
            self.commentNumLabel.text = @"99+";
        }else{
         self.commentNumLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.commentArray.count];
        }
    } Fail:^(NSString *errorMsg) {
        self.commentNumLabel.text = @"0";
        self.commentArray = @[];
    }];
    
}

- (void)observerDurationAction
{
    // 监听播放状态
    [MusicPlayerManager sharedManager].progressBlock = ^(CGFloat f, NSString *loadTime, NSString *totalTime, BOOL isPlayCompletion) {
        self.currentTimeLabel.text = loadTime;
        self.sumTimeLabel.text = totalTime;
        self.progressView.progress = f;
        self.sliderView.value = f;
    };
}

#pragma mark - 点击事件
// 点击封面
- (void)showDetialAction
{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    MusicDetialView *detialView = [[MusicDetialView alloc]initWithFrame:keyWindow.bounds];
    detialView.model = self.dataSource[self.currentIndex];
    // 过度动画
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    CATransition *animation = [CATransition animation];
    animation.duration = 0.6;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    animation.subtype = kCATransitionFromBottom;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [window makeKeyAndVisible];
    
    [keyWindow addSubview:detialView];
}
// 播放
- (void)playButtonClick:(UIButton *)sender
{
    if (![[MusicPlayerManager sharedManager].fsController isPlaying]) {
        // 开始/继续播放
//        sender.selected = YES;
        [sender setImage:[UIImage imageNamed:@"music_btn_pause"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"music_btn_pause_prs"] forState:UIControlStateHighlighted];
        
        [[MusicPlayerManager sharedManager].fsController playFromPlaylist:self.playItemArray itemIndex:self.currentIndex];
        [self setupLockScreenInfo]; // 刷新锁屏信息
        [MusicPlayerManager sharedManager].progressBlock = ^(CGFloat f, NSString *loadTime, NSString *totalTime, BOOL isPlayCompletion) {
            if (isPlayCompletion) {
                // 播放完毕
                FSPlaylistItem *currentItem = [[MusicPlayerManager sharedManager].fsController currentPlaylistItem];
                NSInteger currentIndex = self.currentIndex;
                for (FSPlaylistItem *item in self.playItemArray) {
                    if ([item isEqual:currentItem]) {
                        currentIndex = item.listID;
                    }
                }
                self.currentIndex = currentIndex;
                AlbumInfoModel *model = self.dataSource[self.currentIndex];
                [self reloadULAction:model];
                
                self.currentTimeLabel.text = loadTime;
                self.sumTimeLabel.text = totalTime;
                self.progressView.progress = f;
                self.sliderView.value = f;
                
            }else{
                self.currentTimeLabel.text = loadTime;
                self.sumTimeLabel.text = totalTime;
                self.progressView.progress = f;
                self.sliderView.value = f;
            }
        };
        
    }else{
        // 暂停播放，进入界面不自动执行暂停事件
//        sender.selected = NO;
        [sender setImage:[UIImage imageNamed:@"music_btn_play"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"music_btn_play_prs"] forState:UIControlStateHighlighted];
        
        [[MusicPlayerManager sharedManager].fsController pause];
    }

}
// 滑动UISlider
- (void)sliderMoveAction:(UISlider *)slider
{
    KGLog(@"slider进度 = %f",slider.value);
    CGFloat sliderValue = slider.value;
    FSStreamPosition position;
    position.position = sliderValue;
    [[MusicPlayerManager sharedManager].fsController.activeStream seekToPosition:position];
    [[MusicPlayerManager sharedManager].fsController.activeStream play];
}
// 歌曲换了或其他问题，刷新UI界面
- (void)reloadULAction:(AlbumInfoModel *)model
{
    [self.centerImgView sd_setImageWithURL:[NSURL URLWithString:model.music_logo] placeholderImage:[UIImage imageWithColor:MainColor]];
    self.titleLabel.text = model.music_name;
    self.writerLabel.text = model.music_author;
}
// 上一首
- (void)lastButtonClick:(UIButton *)sender
{
    if ([[MusicPlayerManager sharedManager].fsController hasPreviousItem]) {
        self.currentIndex--;
        AlbumInfoModel *model = self.dataSource[self.currentIndex];
        [self reloadULAction:model];
        
        [[MusicPlayerManager sharedManager].fsController playPreviousItem];
        [self setupLockScreenInfo]; // 刷新锁屏信息
    }else{
        self.currentIndex = self.playItemArray.count - 1;
        AlbumInfoModel *model = self.dataSource[self.currentIndex];
        [self reloadULAction:model];
        
        [[MusicPlayerManager sharedManager].fsController playFromPlaylist:self.playItemArray itemIndex:self.currentIndex];
        [self setupLockScreenInfo]; // 刷新锁屏信息
    }
}
// 下一首
- (void)nextButtonClick:(UIButton *)sender
{
    if ([[MusicPlayerManager sharedManager].fsController hasNextItem]) {
        self.currentIndex++;
        AlbumInfoModel *model = self.dataSource[self.currentIndex];
        [self reloadULAction:model];
        
        [[MusicPlayerManager sharedManager].fsController playNextItem];
        [self setupLockScreenInfo]; // 刷新锁屏信息
    }else{
        self.currentIndex = 0;
        AlbumInfoModel *model = self.dataSource[self.currentIndex];
        [self reloadULAction:model];
        
        [[MusicPlayerManager sharedManager].fsController playFromPlaylist:self.playItemArray itemIndex:self.currentIndex];
        [self setupLockScreenInfo]; // 刷新锁屏信息
    }
}
// 播放顺序
- (void)typeButtonClick:(UIButton *)sender
{
    [self showPopTipsWithMessage:@"暂只支持顺便播放" AtView:self.playTypeButton inView:self.view];
}
// 播放列表
- (void)listButtonClick:(UIButton *)sender
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    PlayListView *playList = [[PlayListView alloc]initWithArray:self.dataSource CurrentIndex:self.currentIndex];
    playList.SelectModelBlock = ^(AlbumInfoModel *model, NSInteger selectIndex) {
        if (self.currentIndex == selectIndex) {
            // 选中的是同一首
            NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
            [UD setObject:[NSString stringWithFormat:@"%ld",selectIndex] forKey:LastMusicIndex];
            [UD synchronize];
            
        }else{
            // 选择其他的
            self.currentIndex = selectIndex;
            NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
            [UD setObject:[NSString stringWithFormat:@"%ld",selectIndex] forKey:LastMusicIndex];
            [UD synchronize];
            [[MusicPlayerManager sharedManager].fsController stop];
            [[MusicPlayerManager sharedManager].fsController playFromPlaylist:self.playItemArray itemIndex:self.currentIndex];
            [self setupLockScreenInfo]; // 刷新锁屏信息
            [MusicPlayerManager sharedManager].progressBlock = ^(CGFloat f, NSString *loadTime, NSString *totalTime, BOOL isPlayCompletion) {
                if (isPlayCompletion) {
                    // 播放完毕
                    FSPlaylistItem *currentItem = [[MusicPlayerManager sharedManager].fsController currentPlaylistItem];
                    NSInteger currentIndex = self.currentIndex;
                    for (FSPlaylistItem *item in self.playItemArray) {
                        if ([item isEqual:currentItem]) {
                            currentIndex = item.listID;
                        }
                    }
                    self.currentIndex = currentIndex;
                    AlbumInfoModel *model = self.dataSource[self.currentIndex];
                    [self reloadULAction:model];
                    self.currentTimeLabel.text = loadTime;
                    self.sumTimeLabel.text = totalTime;
                    self.progressView.progress = f;
                    self.sliderView.value = f;
                }else{
                    // 还在播放
                    self.currentTimeLabel.text = loadTime;
                    self.sumTimeLabel.text = totalTime;
                    self.progressView.progress = f;
                    self.sliderView.value = f;
                }
            };
            // 修改刷新UI界面
            [self reloadULAction:self.dataSource[self.currentIndex]];
        }
    };
    playList.frame = keyWindow.bounds;
    [keyWindow addSubview:playList];
}
// 下载
- (void)downLoadButtonClick:(UIButton *)sender
{
//    [[TTLFManager sharedManager].networkManager downLoadMusicWithModel:self.dataSource[self.currentIndex] Progress:^(NSProgress *progress) {
//        
//        KGLog(@"下载进度 = %g",progress.fractionCompleted);
//        
//    } Success:^(NSString *string) {
//        [self sendAlertAction:string];
//    } Fail:^(NSString *errorMsg) {
//        [self sendAlertAction:errorMsg];
//    }];
}
// 评论
- (void)commentButtonClick:(UIButton *)sender
{
    AlbumInfoModel *model = self.dataSource[self.currentIndex];
    CommentMusicController *comment = [[CommentMusicController alloc]initWithModel:model WithArray:self.commentArray];
    comment.CommentNumBlock = ^(NSArray *commentArray) {
        self.commentArray = commentArray;
        if (self.commentArray.count > 99) {
            self.commentNumLabel.text = @"99+";
        }else{
            self.commentNumLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.commentArray.count];
        }
    };
    [self.navigationController pushViewController:comment animated:YES];

}



#pragma mark - 辅助方法
// 获取播放总时长
- (NSString *)durationTimeWithVideo:(NSURL *)videoUrl
{
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoUrl options:opts]; // 初始化视频媒体文件
    NSUInteger second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    NSString *time = [self timeFormatted:second];
    
    return time;
}
- (NSString *)timeFormatted:(NSUInteger)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    NSString *totlaTime = [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
    self.sumTimeLabel.text = totlaTime;
    return totlaTime;
}



#pragma mark - 其他周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
    [self beginLightingAction];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //注意这里，告诉系统已经准备好了
    [self becomeFirstResponder];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //注意这里，告诉系统已经准备好了
    [self becomeFirstResponder];
    
    
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
//音乐锁屏信息展示
- (void)setupLockScreenInfo
{
    AlbumInfoModel *model = self.dataSource[self.currentIndex];
    MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    // 歌名
    NSMutableDictionary *playingInfoDict = [NSMutableDictionary dictionary];
    [playingInfoDict setObject:model.music_name forKey:MPMediaItemPropertyAlbumTitle];
    // 作者
    [playingInfoDict setObject:model.music_author forKey:MPMediaItemPropertyArtist];
    // 封面
    UIImage *image = [self getMusicImageWithMusicId:model];
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
    [playingInfoDict setObject:artwork forKey:MPMediaItemPropertyArtwork];
    // 播放时长
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:model.music_desc] options:opts]; // 初始化视频媒体文件
    NSUInteger second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    [playingInfoDict setObject:@(second) forKey:MPMediaItemPropertyPlaybackDuration];
    
    playingInfoCenter.nowPlayingInfo = playingInfoDict;
    // 开启远程交互
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
}
//获取远程网络图片，如有缓存取缓存，没有缓存，远程加载并缓存
- (UIImage*)getMusicImageWithMusicId:(AlbumInfoModel *)model
{
    
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:model.music_logo];
    if (cachedImage) {
        return cachedImage;
    }else{
        UIImage *image = self.centerImgView.image;
        return image;
    }
}

// 重写父类方法，接受外部事件的的处理
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
//    [super remoteControlReceivedWithEvent:event];
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                // 暂停 iOS6
                [[MusicPlayerManager sharedManager].fsController pause];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                // 上一首
                [self lastButtonClick:self.lastButton];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                // 下一首
                [self nextButtonClick:self.nextButton];
                break;
            case UIEventSubtypeRemoteControlPlay:
                // 继续播放，有问题
                [[MusicPlayerManager sharedManager].fsController play];
                break;
            case UIEventSubtypeRemoteControlPause:
                // 暂停 iOS7
                [[MusicPlayerManager sharedManager].fsController pause];
                break;
                
            default:
                break;
        }
    }
}
// 传递信息到锁屏状态下此方法在播放歌曲与切换歌曲时调用即可

- (void)beginLightingAction
{
    // 继续发光
    [self.circleImgView.layer addAnimation:self.xuanzhuanAnimation forKey:@"rotationAnimation"];//开始动画
}

#pragma mark - 方法代理

- (void)shareViewClickWithType:(ShareViewClickType)type
{
    AlbumInfoModel *model = self.dataSource[self.currentIndex];
    
    NSString *url = [NSString stringWithFormat:@"%@&userID=%@",model.web_url,[AccountTool account].userID.base64EncodedString];
//    NSString *url = model.music_desc;
    NSString *title = model.music_name;
    NSString *descStr = model.music_author;
    UIImage *image;
    NSData *imageData = UIImageJPEGRepresentation(self.centerImgView.image, 0.01);
    NSInteger len = imageData.length / 1024;
    if (len > 32) {
        image = [UIImage imageNamed:@"app_logo"];
    }else{
        image = self.centerImgView.image;
    }
    
    if (type == WechatFriendType) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
        message.description = descStr;
        [message setThumbImage:image];
        
        WXWebpageObject *musicObject = [WXWebpageObject object];
        musicObject.webpageUrl = url;
        message.mediaObject = musicObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = 0;
        [WXApi sendReq:req];
    }else if (type == WechatQuanType){
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
        message.description = descStr;
        [message setThumbImage:image];
        
        WXWebpageObject *musicObject = [WXWebpageObject object];
        musicObject.webpageUrl = url;
        message.mediaObject = musicObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = 1;
        [WXApi sendReq:req];
    }else if (type == QQFriendType){
        
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:title description:descStr previewImageData:UIImagePNGRepresentation(image)];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        QQApiSendResultCode qqFriend = [QQApiInterface sendReq:req];
        [self sendToQQWithSendResult:qqFriend];
        
    }else if (type == QQSpaceType){
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:title description:descStr previewImageData:UIImagePNGRepresentation(image)];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        QQApiSendResultCode qqZone = [QQApiInterface SendReqToQZone:req];
        [self sendToQQWithSendResult:qqZone];
    }else if (type == SinaShareType){
        [MBProgressHUD showSuccess:@"新浪微博"];
    }else if (type == SysterShareType){
        
        UIActivityViewController *activity = [[UIActivityViewController alloc]initWithActivityItems:@[image,title,[NSURL URLWithString:url]] applicationActivities:nil];
        [self presentViewController:activity animated:YES completion:^{
            
        }];
    }else if (type == WechatStoreType){
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
        message.description = descStr;
        [message setThumbImage:image];
        
        WXWebpageObject *webObject = [WXWebpageObject object];
        webObject.webpageUrl = url;
        message.mediaObject = webObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = 2;
        [WXApi sendReq:req];
    }
}

- (NSMutableArray *)playItemArray
{
    if (!_playItemArray) {
        _playItemArray = [NSMutableArray array];
    }
    return _playItemArray;
}

@end
