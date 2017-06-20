//
//  BookCacheManager.h
//  TTLF
//
//  Created by Chan_Sir on 2017/6/14.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookInfoModel.h"

/********** 书架的缓存 ***********/

@interface BookCacheManager : NSObject

/**
 初始化
 
 @return BookCacheManager对象
 */
+ (instancetype)sharedManager;

/**
 保存景区模型
 
 @param bookModel 景区模型
 */
- (void)saveBookArrayWithModel:(BookInfoModel *)bookModel;

/**
 缓存中的景区模型
 
 @return 缓存数组
 */
- (NSArray *)getBookCacheArray;

/**
 删除某本典籍

 @param bookID 典籍ID
 */
- (void)deleteOneBookByBookID:(NSString *)bookID;

/**
 清理缓存
 */
- (void)deleBookCache;


@end
