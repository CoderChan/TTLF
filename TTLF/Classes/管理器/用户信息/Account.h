//
//  Account.h
//  FYQ
//
//  Created by Chan_Sir on 2017/2/24.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********** 主要保存一些固定的信息，如登录名、ID ***********/
@interface Account : NSObject

/** 用户ID */
@property (copy,nonatomic) NSString *userID;
/** 微信的unionid */
@property (copy,nonatomic) NSString *unionid;


+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
