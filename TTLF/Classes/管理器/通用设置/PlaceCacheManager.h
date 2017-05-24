//
//  PlaceCacheManager.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/24.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceDetialModel.h"


/******* 佛教名山首页缓存 ********/
@interface PlaceCacheManager : NSObject


/**
 初始化

 @return PlaceCacheManager对象
 */
+ (instancetype)sharedManager;

/**
 保存景区模型

 @param placeModel 景区模型
 */
- (void)savePlaceArrayWithModel:(PlaceDetialModel *)placeModel;

/**
 缓存中的景区模型

 @return 缓存数组
 */
- (NSArray *)getPlaceCacheArray;

/**
 清理缓存
 */
- (void)delePlaceCache;


@end
