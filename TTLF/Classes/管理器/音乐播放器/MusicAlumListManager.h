//
//  MusicAlumListManager.h
//  TTLF
//
//  Created by Chan_Sir on 2017/8/13.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlbumInfoModel.h"

/************ 梵音专辑列表 **********/

@interface MusicAlumListManager : NSObject

/**
 初始化
 
 @return MusicAlumListManager对象
 */
+ (instancetype)sharedManager;


/**
 保存梵音模型

 @param albumModel 专辑列表
 */
- (void)saveMusicArrayWithModel:(AlbumInfoModel *)albumModel;


/**
 上次播放的专辑列表

 */
- (NSArray *)getLastMusicListCacheArray;

/** 某个分类下的专辑列表 */
- (NSArray *)getAlbumListByCateID:(MusicCateModel *)cateModel;

/**
 清理缓存
 */
- (void)deleMusicCateCache;



@end
