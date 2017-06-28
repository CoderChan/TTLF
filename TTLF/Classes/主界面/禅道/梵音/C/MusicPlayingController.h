//
//  MusicPlayingController.h
//  TTLF
//
//  Created by Chan_Sir on 2017/6/25.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface MusicPlayingController : SuperViewController


/**
 初始化

 @param dataSource 播放清单
 @param currentIndex 当前播放的索引
 @return MusicPlayingController
 */
- (instancetype)initWithArray:(NSArray *)dataSource CurrentIndex:(NSInteger)currentIndex;

@end
