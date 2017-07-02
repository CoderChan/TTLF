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

// 播放器
@property (strong,nonatomic) FSAudioController *fsController;
// 播放进度
@property (nonatomic,copy) void (^progressBlock)(CGFloat f,NSString *loadTime,NSString *totalTime,BOOL isPlayCompletion);


// 代理
@property (weak,nonatomic) id<MusicPlayDelegate> delegate;




@end
