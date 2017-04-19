//
//  DynamicModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/11.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationModel.h"
#import "SendTopicModel.h"

/******* 首页的动态模型 ********/

@interface DynamicModel : NSObject

/** 动态ID */
@property (copy,nonatomic) NSString *dynamicID;
/** 发布者用户模型 */
@property (strong,nonatomic) UserInfoModel *userModel;
/** 是否匿名 */
@property (assign,nonatomic) BOOL isNiming;
/** 内容 */
@property (copy,nonatomic) NSString *content;
/** 附带图：没有则为空 */
@property (copy,nonatomic) NSString *imgUrl;
/** 地理位置信息 */
@property (strong,nonatomic) LocationModel *locationModel;
/** 话题模型 */
@property (strong,nonatomic) SendTopicModel *topicModel;
/** 评论数 */
@property (assign,nonatomic) int discussCount;
/** 点赞数 */
@property (assign,nonatomic) int zanCount;
/** 我是否已点赞 */
@property (assign,nonatomic) BOOL isZan;
/** 我是否已评论 */
@property (assign,nonatomic) BOOL isDiscuss;
/** 发布的时间 */
@property (assign,nonatomic) NSTimeInterval time;


@end
