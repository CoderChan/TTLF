//
//  AddressCacheManager.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/31.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressCacheManager.h"

/******* 缓存我的收货地址 ********/
@interface AddressCacheManager : NSObject

/**
 初始化
 
 @return AddressCacheManager对象
 */
+ (instancetype)sharedManager;

/**
 保存收货地址

 @param addressModel 地址模型
 */
- (void)saveAddressArrayWithModel:(AddressModel *)addressModel;

/**
 获取收货地址缓存

 @return 缓存数组
 */
- (NSArray *)getAddressArray;

/**
 清理地址缓存
 */
- (void)deleteAddressCache;


@end
