//
//  MusicPlayerManager.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/29.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MusicPlayerManager.h"
#import "MusicCacheManager.h"

@interface MusicPlayerManager ()<FSAudioControllerDelegate>

{
    NSTimer *_progressUpdateTimer;
}

@end

@implementation MusicPlayerManager

#pragma mark - 初始化
+ (instancetype)sharedManager
{
    static MusicPlayerManager *playerManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        playerManager = [[self alloc]init];
    });
    return playerManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 预设一些信息
        
    }
    return self;
}

#pragma mark - 开始播放
- (void)beginPlayWithModel:(AlbumInfoModel *)model
{
    // 先检测有没有缓存，有缓存就播放
    NSString *cachePath = [self searchFilePathByFileName:model.name];
    if (cachePath) {
        // 已经下载。直接播放本地音乐
        
    }else{
        // 没有下载，播放网络流媒体
        self.fsController = nil;
        self.fsController = [[FSAudioController alloc]initWithUrl:[NSURL URLWithString:model.music_desc]];
        self.fsController.delegate = self;
        [self.fsController play];
        
        // 记录当前播放的音乐ID
        NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
        [UD setObject:model.music_id forKey:LastMusicID];
        [UD synchronize];
        
    }
}
#pragma mark - 继续播放
- (void)continuePlay
{
//    [self.fsController play];
}
#pragma mark - 是否正在播放
- (BOOL)isPlaying
{
    return [self.fsController isPlaying];
}
#pragma mark - 暂停播放
- (void)pause
{
    [self.fsController pause];
}

#pragma mark - 停止播放
- (void)stop
{
    [self.fsController stop];
    // 清除当前播放的音乐ID
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    [UD removeObjectForKey:LastMusicID];
}

#pragma mark - 代理
- (BOOL)audioController:(FSAudioController *)audioController allowPreloadingForStream:(FSAudioStream *)stream
{
    NSLog(@"stream1 = %@",stream);
    return YES;
}
- (void)audioController:(FSAudioController *)audioController preloadStartedForStream:(FSAudioStream *)stream
{
    NSLog(@"stream2 = %@",stream);
}
// 判断文件是否已经在沙盒中已经存在？
- (NSString *)searchFilePathByFileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    if (result) {
        return filePath;
    }else{
        return nil;
    }
}

- (FSAudioController *)fsController
{
    if (!_fsController) {
        _fsController = [[FSAudioController alloc]init];
        _fsController.delegate = self;
        [YLNotificationCenter addObserver:self selector:@selector(audioStreamStateDidChange:) name:FSAudioStreamStateChangeNotification object:nil];
        [YLNotificationCenter addObserver:self selector:@selector(audioStreamErrorOccurred:) name:FSAudioStreamErrorNotification object:nil];
        [YLNotificationCenter addObserver:self selector:@selector(audioStreamMetaDataAvailable:) name:FSAudioStreamMetaDataNotification object:nil];
    }
    return _fsController;
}

- (void)audioStreamStateDidChange:(NSNotification *)notification {
    
    NSString *statusRetrievingURL = @"Retrieving stream URL";
    NSString *statusBuffering = @"Buffering...";
    NSString *statusSeeking = @"Seeking...";
    NSString *statusEmpty = @"";
    
    NSDictionary *dict = [notification userInfo];
    int state = [[dict valueForKey:FSAudioStreamNotificationKey_State] intValue];
    switch (state) {
        case kFsAudioStreamRetrievingURL:
            if (_progressUpdateTimer) {
                [_progressUpdateTimer invalidate];
            }
            NSLog(@"%@",statusRetrievingURL);
            break;
        case kFsAudioStreamStopped:
            NSLog(@"%@",statusEmpty);
            if (_progressUpdateTimer) {
                [_progressUpdateTimer invalidate];
            }
            break;
        case kFsAudioStreamBuffering:
            NSLog(@"%@",statusBuffering);
            if (_progressUpdateTimer) {
                [_progressUpdateTimer invalidate];
            }
            break;
        case kFsAudioStreamSeeking:
            NSLog(@"%@",statusSeeking);
            break;
        case kFsAudioStreamPlaying:
            if (_progressUpdateTimer) {
                [_progressUpdateTimer invalidate];
            }
            _progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updatePlaybackProgress) userInfo:nil repeats:YES];
            break;
        case kFsAudioStreamFailed:
            if (_progressUpdateTimer) {
                [_progressUpdateTimer invalidate];
            }
            break;
        default:
            break;
    }
}
- (void)updatePlaybackProgress
{
    if (self.fsController.activeStream.continuous) {
        //        [self.progressTextFieldCell setTitle:@""];
    } else {
        FSStreamPosition cur = self.fsController.activeStream.currentTimePlayed;
        FSStreamPosition end = self.fsController.activeStream.duration;
        CGFloat loadTime = cur.minute *60 + cur.second;
        CGFloat totalTime = end.minute*60 + end.second;
        NSString *loadDate = [NSString stringWithFormat:@"%i:%02i",cur.minute, cur.second];
        NSString *totalDate = [NSString stringWithFormat:@"%i:%02i",end.minute, end.second];
        if (self.progressBlock) {
            self.progressBlock(loadTime/totalTime,loadDate,totalDate);
        }
        NSLog(@"%@",[NSString stringWithFormat:@"%i:%02i / %i:%02i",
                             cur.minute, cur.second,
                             end.minute, end.second]);
    }
}

- (void)audioStreamErrorOccurred:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    int errorCode = [[dict valueForKey:FSAudioStreamNotificationKey_Error] intValue];
    
    switch (errorCode) {
        case kFsAudioStreamErrorOpen:
            NSLog(@"Cannot open the audio stream");
            break;
        case kFsAudioStreamErrorStreamParse:
            NSLog(@"Cannot read the audio stream");
            break;
        case kFsAudioStreamErrorNetwork:
            NSLog(@"Network failed: cannot play the audio stream");
            break;
        default:
            NSLog(@"Unknown error occurred");
            break;
    }
}

- (void)audioStreamMetaDataAvailable:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    NSDictionary *metaData = [dict valueForKey:FSAudioStreamNotificationKey_MetaData];
    NSString *streamTitle = [metaData objectForKey:@"StreamTitle"];
    NSLog(@"%@",streamTitle);
}

- (void)dealloc {
    [YLNotificationCenter removeObserver:self name:FSAudioStreamStateChangeNotification object:nil];
    [YLNotificationCenter removeObserver:self name:FSAudioStreamErrorNotification object:nil];
    [YLNotificationCenter removeObserver:self name:FSAudioStreamMetaDataNotification object:nil];
    [_progressUpdateTimer invalidate];
    _progressUpdateTimer = nil;
}

@end
