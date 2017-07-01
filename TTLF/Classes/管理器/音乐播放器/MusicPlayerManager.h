//
//  MusicPlayerManager.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/29.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSAudioController.h"
#import "FSAudioStream.h"

@class MusicPlayerManager;

@protocol MusicPlayDelegate <NSObject>

- (BOOL)musicManager:(MusicPlayerManager *)musicPlayManager allowPreloadingForStream:(FSAudioStream *)stream;

- (void)musicManager:(MusicPlayerManager *)musicPlayManager preloadStartedForStream:(FSAudioStream *)stream;

@end

@interface MusicPlayerManager : NSObject


// 单例初始化
+ (instancetype)sharedManager;

// 代理
@property (weak,nonatomic) id<MusicPlayDelegate> delegate;

// 播放
- (void)beginPlayWithModel:(AlbumInfoModel *)model;
// 继续播放
- (void)continuePlay;
// 是否正在播放
- (BOOL)isPlaying;
//  暂停播放
- (void)pause;
//  停止播放
- (void)stop;



@end
