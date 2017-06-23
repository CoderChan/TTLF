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


@property (strong,nonatomic) AVPlayer *player;

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

#pragma mark - 播放网络音乐
- (void)playNetMusic
{
    [self.player play];
}

#pragma mark - 播放本地音乐
- (void)playLocalMusic
{
    
    
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
    [self.player pause];
}

- (AVPlayer *)player
{
    if (!_player) {
        AVPlayerItem *playItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:@"http://app.yangruyi.com/Uploads/admin/2017-06-23/594c8fa376a60.mp3"]];
        _player = [[AVPlayer alloc]initWithPlayerItem:playItem];
    }
    return _player;
}

@end
