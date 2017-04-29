//
//  TTLFManager.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "TTLFManager.h"

@implementation TTLFManager

+ (instancetype)sharedManager
{
    static TTLFManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.networkManager = [NetworkDataManager sharedManager];
        self.musicManager = [MusicPlayerManager sharedManager];
        self.userManager = [UserInfoManager sharedManager];
    }
    return self;
}


@end
