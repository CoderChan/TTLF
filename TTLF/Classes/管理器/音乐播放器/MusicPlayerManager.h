//
//  MusicPlayerManager.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/29.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicPlayerManager : NSObject


/**
 初始化

 @return MusicPlayerManager
 */
+ (instancetype)sharedManager;

// 是否正在播放
@property (assign,nonatomic) BOOL isPlaying;

/**
 播放本地音乐
 */
- (void)playLocalMusic;


/**
 暂停播放
 */
- (void)pause;

/**
 停止播放
 */
- (void)stop;

@end
