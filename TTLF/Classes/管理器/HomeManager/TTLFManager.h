//
//  TTLFManager.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkDataManager.h"
#import "UserInfoManager.h"
#import "TTLFSetManager.h"

@interface TTLFManager : NSObject

/** 单利初始化 */
+ (instancetype)sharedManager;
/** 网络请求 */
@property (strong,nonatomic) NetworkDataManager *networkManager;
/** 用户信息 */
@property (strong,nonatomic) UserInfoManager *userManager;
/** APP属性 */
@property (strong,nonatomic) TTLFSetManager *setManager;

@end
