//
//  MusicPlayerManager.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/29.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MusicPlayerManager.h"
#import <AVFoundation/AVFoundation.h>

@interface MusicPlayerManager ()

@property (strong,nonatomic) AVAudioPlayer *player;

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
        self.isPlaying = NO;
    }
    return self;
}

#pragma mark - 播放本地音乐
- (void)playLocalMusic
{
    self.isPlaying = YES;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"消灾吉祥神咒" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc]initFileURLWithPath:path];
    NSError *error;
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    if (error) {
        [MBProgressHUD showError:error.localizedDescription];
    }
    self.player.numberOfLoops = -1;
    [self.player play];
    
}
#pragma mark - 暂停播放
- (void)pause
{
    self.isPlaying = NO;
    [self.player pause];
}
#pragma mark - 停止播放
- (void)stop
{
    self.isPlaying = NO;
    [self.player stop];
}

//- (AVAudioPlayer *)player
//{
//    if (!_player) {
//        _player = [[AVAudioPlayer alloc]init];
//    }
//    return _player;
//}

@end
