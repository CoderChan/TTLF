//
//  NewsCacheManager.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/24.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsArticleModel.h"

/******* 佛友圈文章缓存 *******/
@interface NewsCacheManager : NSObject


/**
 初始化

 @return NewsCacheManager对象
 */
+ (instancetype)sharedManager;

/**
 保存文章数据

 @param newsModel 文章模型
 */
- (void)saveNewsArrayWithModel:(NewsArticleModel *)newsModel;

/**
 获取文章缓存

 @return 缓存数组
 */
- (NSArray *)getNewsCacheArray;

/**
 清理缓存
 */
- (void)deleteNewsCache;

@end
