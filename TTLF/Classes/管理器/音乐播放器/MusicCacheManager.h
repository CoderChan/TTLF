//
//  MusicCacheManager.h
//  TTLF
//
//  Created by Chan_Sir on 2017/6/25.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlbumInfoModel.h"


/** 梵音专辑列表 */
@interface MusicCacheManager : NSObject

/**
 初始化
 
 @return MusicCacheManager对象
 */
+ (instancetype)sharedManager;

/**
 保存梵音模型
 
 @param musicModel 梵音模型
 */
- (void)saveMusicArrayWithModel:(AlbumInfoModel *)musicModel;

/**
 缓存中的梵音模型
 
 @return 缓存数组
 */
- (NSArray *)getMusicCacheArray;

/**
 删除某个梵音
 
 @param musicID 梵音ID
 */
- (void)deleteOneMusicByMusicID:(NSString *)musicID;

/**
 清理缓存
 */
- (void)deleMusicCache;


@end
