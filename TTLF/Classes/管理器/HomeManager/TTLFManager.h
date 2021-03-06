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
#import "MusicPlayerManager.h"
#import "FoNewsViewController.h"
#import "LiFoViewController.h"
#import "RootTabbarController.h"


@interface TTLFManager : NSObject

/** 单利初始化 */
+ (instancetype)sharedManager;
/** 网络请求 */
@property (strong,nonatomic) NetworkDataManager *networkManager;
/** 用户信息 */
@property (strong,nonatomic) UserInfoManager *userManager;
/** 音乐播放属性 */
@property (strong,nonatomic) MusicPlayerManager *musicManager;

/** 礼佛界面 */
@property (weak,nonatomic) LiFoViewController *lifoVC;
/** 第一个界面 */
@property (weak,nonatomic) FoNewsViewController *homeVC;
/** Tabbar */
@property (weak,nonatomic) RootTabbarController *tabbar;


@end
