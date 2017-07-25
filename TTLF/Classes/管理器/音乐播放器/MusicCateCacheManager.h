//
//  MusicCateCacheManager.h
//  TTLF
//
//  Created by Chan_Sir on 2017/7/12.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicCateModel.h"

/******** 梵音分类列表 *********/

@interface MusicCateCacheManager : NSObject

/**
 初始化
 
 @return MusicCateCacheManager对象
 */
+ (instancetype)sharedManager;

/**
 保存梵音模型
 
 @param cateModel 梵音分类模型
 */
- (void)saveMusicArrayWithModel:(MusicCateModel *)cateModel;

/**
 缓存中的梵音模型
 
 @return 缓存数组
 */
- (NSArray *)getMusicCacheArray;

/**
 删除某个梵音
 
 @param cateID 梵音分类ID
 */
- (void)deleteOneMusicByMusicID:(NSString *)cateID;

/**
 清理缓存
 */
- (void)deleMusicCateCache;


@end
