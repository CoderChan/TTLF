//
//  SendTopicModel.h
//  FYQ
//
//  Created by Chan_Sir on 2017/3/6.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendTopicModel : NSObject

/** 话题ID */
@property (copy,nonatomic) NSString *topic_id;
/** 话题名称 */
@property (copy,nonatomic) NSString *topic_name;
/** 创建时间 */
@property (copy,nonatomic) NSString *create_time;
/** 排序 */
@property (copy,nonatomic) NSString *topic_asc;

@end
