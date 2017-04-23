//
//  TTLFSettingManager.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/23.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "TTLFSettingManager.h"

@implementation TTLFSettingManager

+ (instancetype)sharedManager
{
    static TTLFSettingManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}


@end
