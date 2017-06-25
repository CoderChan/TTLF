//
//  MusicPlayingController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/6/23.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MusicPlayingController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Masonry.h>
#import "ShareView.h"
#import "CommentMusicController.h"

@interface MusicPlayingController ()<ShareViewDelegate>

// 当前播放的mp3模型
@property (strong,nonatomic) AlbumInfoModel *currentModel;
// 播放列表
@property (copy,nonatomic) NSArray *dataSource;
// 当前播放的索引
@property (assign,nonatomic) NSInteger currentIndex;
// 播放器
@property (strong,nonatomic) AVPlayer *player;
// 背景图
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (strong,nonatomic) CABasicAnimation *rotationAnimation;
// 歌曲图
@property (weak, nonatomic) IBOutlet UIImageView *centerImgView;
// 歌名
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
// 作者
@property (weak, nonatomic) IBOutlet UILabel *writerLabel;
// 进度条
@property (weak, nonatomic) IBOutlet UIProgressView *loadTimeProgress;
// 进度条控制器
@property (weak, nonatomic) IBOutlet UISlider *sliderView;
// 下载按钮
@property (weak, nonatomic) IBOutlet UIButton *downButton;
// 播放按钮
@property (weak, nonatomic) IBOutlet UIButton *playButton;
// 评论按钮
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
// 开始时间
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
// 结束时间
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
// 顺序按钮
@property (weak, nonatomic) IBOutlet UIButton *shunxuButton;
// 歌单按钮
@property (weak, nonatomic) IBOutlet UIButton *musicListButton;

//当前歌曲进度监听者
@property(nonatomic,strong) id timeObserver;

@end

@implementation MusicPlayingController


- (instancetype)initWithArray:(NSArray *)dataSource CurrentIndex:(NSInteger)currentIndex
{
    self = [super init];
    if (self) {
        self.dataSource = dataSource;
        self.currentIndex = currentIndex;
        self.currentModel = self.dataSource[currentIndex];
//        NSString *testUrl = @"http://download.lingyongqian.cn/music/ForElise.mp3";
//        self.currentModel.music_desc = testUrl;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    
    [YLNotificationCenter addObserver:self selector:@selector(beginLightingAction) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)setupSubViews
{
    if (SCREEN_WIDTH == 375) {
        self.backImgView.image = [UIImage imageNamed:@"cm2_fm_bg_ip6"];
    }else{
        self.backImgView.image = [UIImage imageNamed:@"cm2_fm_bg"];
    }
    
    [self.downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerImgView.mas_left);
        make.bottom.equalTo(self.sliderView.mas_top).offset(-20);
        make.width.and.height.equalTo(@40);
    }];
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerImgView.mas_right);
        make.centerY.equalTo(self.downButton.mas_centerY);
        make.width.and.height.equalTo(@40);
    }];
    
    // 封面图
    [self.centerImgView sd_setImageWithURL:[NSURL URLWithString:self.currentModel.music_logo] placeholderImage:[UIImage imageWithColor:MainColor]];
    self.centerImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.centerImgView setContentScaleFactor:[UIScreen mainScreen].scale];
    self.centerImgView.layer.masksToBounds = YES;
    self.centerImgView.layer.cornerRadius = 100.f;
    self.centerImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight & UIViewAutoresizingFlexibleWidth;
    UITapGestureRecognizer *centerImgTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [MBProgressHUD showNormal:@"马克"];
    }];
    [self.centerImgView addGestureRecognizer:centerImgTap];
    
    // 添加旋转动画
    self.rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    self.rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    self.rotationAnimation.duration = 7;
    self.rotationAnimation.cumulative = YES;
    self.rotationAnimation.repeatCount = 100000;
    [self.centerImgView.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];//开始动画
    
    // 标题
    self.titleLabel.text = self.currentModel.music_name;
    // 作者
    NSString *sumStr = [NSString stringWithFormat:@"- %@ -",self.currentModel.music_author];
    NSRange range = [sumStr rangeOfString:self.currentModel.music_author];
    NSMutableAttributedString * graytext = [[NSMutableAttributedString alloc] initWithString:sumStr];
    [graytext beginEditing];
    [graytext addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:MainColor} range:range];
    self.writerLabel.attributedText =  graytext;
    
    // 进度条
    self.sliderView.tintColor = MainColor;
    [self.sliderView setThumbImage:[UIImage imageNamed:@"slider_icon"] forState:UIControlStateNormal];
    [self.sliderView setThumbImage:[UIImage imageNamed:@"slider_icon"] forState:UIControlStateHighlighted];
    
    self.loadTimeProgress.tintColor = MainColor;
    
    
    // 开始播放
    [self playClickAction:self.playButton];
}

#pragma mark - NSNotification
-(void)addNSNotificationForPlayMusicFinish
{
    [YLNotificationCenter removeObserver:self];
    //给AVPlayerItem添加播放完成通知
    [YLNotificationCenter addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}
- (void)playFinished:(NSNotification *)noti
{
    //播放下一首
    [self nextBtnAction:nil];
}
#pragma mark - 监听音乐各种状态
//通过KVO监听播放器状态
-(void)addPlayStatus
{
    
//    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
}
//移除监听播放器状态
-(void)removePlayStatus
{
    if (self.currentModel == nil) {return;}
    
//    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
}
//移除监听音乐缓冲状态
-(void)removePlayLoadTime
{
    if (self.currentModel == nil) {return;}
//    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}
//KVO监听音乐缓冲状态
-(void)addPlayLoadTime
{
//    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
}

//监听音乐播放的进度
-(void)addMusicProgressWithItem:(AVPlayerItem *)item
{
    //移除监听音乐播放进度
    [self removeTimeObserver];
    __weak typeof(self) weakSelf = self;
    self.timeObserver =  [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //当前播放的时间
        float current = CMTimeGetSeconds(time);
        //总时间
        float total = CMTimeGetSeconds(item.duration);
        if (current) {
            float progress = current / total;
            //更新播放进度条
            weakSelf.sliderView.value = progress;
            weakSelf.startTimeLabel.text = [weakSelf timeFormatted:current];
        }
    }];
    
}
//移除监听音乐播放进度
-(void)removeTimeObserver
{
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
}


#pragma mark - 点击事件
// 关闭
- (IBAction)dismissAction:(UIButton *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
// 分享
- (IBAction)shareAction:(id)sender
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    ShareView *sharedView = [[ShareView alloc]initWithFrame:keyWindow.bounds];
    sharedView.delegate = self;
    [keyWindow addSubview:sharedView];
}
// 切换播放顺序
- (IBAction)switchTypeClick:(UIButton *)sender
{
    
}
// 歌单列表
- (IBAction)musicListClick:(UIButton *)sender
{
    
}
// 点击下载
- (IBAction)downLoadAction:(UIButton *)sender
{
    [MBProgressHUD showMessage:nil];
    [[TTLFManager sharedManager].networkManager downLoadMusicWithModel:self.currentModel Progress:^(NSProgress *progress) {
        
        NSLog(@"下载进度 = %g",progress.fractionCompleted);
    } Success:^(NSString *string) {
        [MBProgressHUD hideHUD];
        [self sendAlertAction:string];
    } Fail:^(NSString *errorMsg) {
        [MBProgressHUD hideHUD];
        [self sendAlertAction:errorMsg];
    }];
}
// 点击评论按钮
- (IBAction)commentClick:(UIButton *)sender
{
    CommentMusicController *comment = [[CommentMusicController alloc]initWithModel:self.currentModel];
    [self.navigationController pushViewController:comment animated:YES];
}

// 播放
- (IBAction)playClickAction:(UIButton *)sender
{
    if (!sender.selected) {
        // 开始播放中/继续播放
        [self playWithModel:self.currentModel];
        sender.selected = YES;
        [sender setImage:[UIImage imageNamed:@"music_btn_pause_prs"] forState:UIControlStateNormal];
    }else{
        // 没有播放
        [sender setImage:[UIImage imageNamed:@"music_btn_play_prs"] forState:UIControlStateNormal];
        [self.player pause];
        [self removePlayStatus];
        [self removePlayLoadTime];
        self.currentModel = nil;
        sender.selected = NO;
    }
}
- (void)playWithModel:(AlbumInfoModel *)model
{
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:model.music_desc]];
    
    //替换当前音乐资源
    [self.player replaceCurrentItemWithPlayerItem:item];
    
    //刷新界面UI
    [self reloadUI:model];
    
    //监听音乐播放完成通知
    [self addNSNotificationForPlayMusicFinish];
    
    //开始播放
    [self.player play];
    
    //监听播放器状态
    [self addPlayStatus];
    
    //监听音乐缓冲进度
    [self addPlayLoadTime];
    
    //监听音乐播放的进度
    [self addMusicProgressWithItem:item];
    
    //音乐锁屏信息展示
    [self setupLockScreenInfo];
}
// 刷新界面
-(void)reloadUI:(AlbumInfoModel*)model
{
    NSURL *url = [NSURL URLWithString:model.music_desc];
    self.startTimeLabel.text = @"00:00";
    NSString *durationStr = [self durationWithVideo:url];
    self.endTimeLabel.text = [NSString stringWithFormat:@"%@",durationStr];
    self.titleLabel.text = model.music_name;
    // 作者
    NSString *sumStr = [NSString stringWithFormat:@"- %@ -",self.currentModel.music_author];
    NSRange range = [sumStr rangeOfString:self.currentModel.music_author];
    NSMutableAttributedString * graytext = [[NSMutableAttributedString alloc] initWithString:sumStr];
    [graytext beginEditing];
    [graytext addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:MainColor} range:range];
    self.writerLabel.attributedText =  graytext;
    [self.centerImgView sd_setImageWithURL:[NSURL URLWithString:model.music_logo] placeholderImage:[UIImage imageWithColor:MainColor]];
    self.playButton.selected = YES;
    self.sliderView.value = 0;
    self.loadTimeProgress.progress = 0;
    
}
- (NSString *)durationWithVideo:(NSURL *)videoUrl{
    
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
    
    return [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
}

#pragma mark - 设置锁屏信息
//音乐锁屏信息展示
- (void)setupLockScreenInfo
{
    // 1.获取锁屏中心
    MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    //初始化一个存放音乐信息的字典
    NSMutableDictionary *playingInfoDict = [NSMutableDictionary dictionary];
    // 2、设置歌曲名
    if (self.currentModel.music_name) {
        [playingInfoDict setObject:self.currentModel.music_name forKey:MPMediaItemPropertyAlbumTitle];
    }
    // 设置歌手名
    if (self.currentModel.music_author) {
        [playingInfoDict setObject:self.currentModel.music_author forKey:MPMediaItemPropertyArtist];
    }
    // 3设置封面的图片
    UIImage *image = [self getMusicImageWithMusicId:self.currentModel];
    if (image) {
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
        [playingInfoDict setObject:artwork forKey:MPMediaItemPropertyArtwork];
    }
    
    // 4设置歌曲的总时长
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.currentModel.music_desc] options:opts]; // 初始化视频媒体文件
    NSUInteger second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    [playingInfoDict setObject:@(second) forKey:MPMediaItemPropertyPlaybackDuration];
    
    //音乐信息赋值给获取锁屏中心的nowPlayingInfo属性
    playingInfoCenter.nowPlayingInfo = playingInfoDict;
    
    // 5.开启远程交互
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}
//获取远程网络图片，如有缓存取缓存，没有缓存，远程加载并缓存
- (UIImage*)getMusicImageWithMusicId:(AlbumInfoModel *)model
{
    UIImage *image = [UIImage imageNamed:@"goods_place"];
    
    return image;
}


//监听远程交互方法
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    
    switch (event.subtype) {
            //播放
        case UIEventSubtypeRemoteControlPlay:{
            [self.player play];
        }
            break;
            //停止
        case UIEventSubtypeRemoteControlPause:{
            [self.player pause];
        }
            break;
            //下一首
        case UIEventSubtypeRemoteControlNextTrack:
            [self nextBtnAction:nil];
            break;
            //上一首
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self lastBtnAction:nil];
            break;
            
        default:
            break;
    }
}



- (IBAction)biaozhunClick:(UIButton *)sender
{
    [sender setImage:[UIImage imageNamed:@"player_btn_bz_sel_normal"] forState:UIControlStateHighlighted];
}

- (IBAction)sqClick:(UIButton *)sender
{
    [sender setImage:[UIImage imageNamed:@"player_btn_sq_sel_normal"] forState:UIControlStateHighlighted];
}
- (IBAction)nextBtnAction:(UIButton *)sender
{
    //取出下一首音乐模型
    if (self.currentIndex +1 > self.dataSource.count -1) {
        self.currentIndex = 0;
    }else{
        self.currentIndex += 1;
    }
    
    [self addPlayStatus];
    [self removePlayStatus];
    [self removePlayLoadTime];
    AlbumInfoModel *model = self.dataSource[self.currentIndex];
    [self playWithModel:model];
}
- (IBAction)lastBtnAction:(UIButton *)sender
{
    //取出下一首音乐模型
    if (self.currentIndex - 1 < 0) {
        self.currentIndex = self.dataSource.count -1;
    }else{
        self.currentIndex -= 1;
    }
    [self removePlayStatus];
    [self removePlayLoadTime];
    AlbumInfoModel *model = self.dataSource[self.currentIndex];
    [self playWithModel:model];
}

#pragma mark - 懒加载
- (AVPlayer *)player
{
    if (!_player) {
        AVPlayerItem *playItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:@""]];
        _player = [[AVPlayer alloc]initWithPlayerItem:playItem];
    }
    return _player;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self beginLightingAction];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
}

- (void)beginLightingAction
{
    // 继续发光
    [self.centerImgView.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];//开始动画
    
}

- (void)shareViewClickWithType:(ShareViewClickType)type
{
    
    NSString *url = [NSString stringWithFormat:@"%@&userID=%@",self.currentModel.web_url,[AccountTool account].userID.base64EncodedString];
//    NSString *url = self.currentModel.music_desc;
    NSString *title = self.currentModel.music_name;
    NSString *descStr = self.currentModel.music_author;
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



@end
//
