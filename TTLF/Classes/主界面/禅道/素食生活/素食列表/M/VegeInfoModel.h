//
//  VegeInfoModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VegeInfoModel : NSObject

/** 素食ID */
@property (copy,nonatomic) NSString *vege_id;
/** 封面 */
@property (copy,nonatomic) NSString *vege_img;
/** 素食名称 */
@property (copy,nonatomic) NSString *vege_name;
/** 需要的食材 */
@property (copy,nonatomic) NSString *vege_food;
/** 步骤图集 */
@property (copy,nonatomic) NSArray *vege_img_desc;
/** 步骤说明 */
@property (copy,nonatomic) NSString *vege_steps;
/** 素食描述 */
@property (copy,nonatomic) NSString *vege_desc;
/** 时间 */
@property (copy,nonatomic) NSString *create_time;
/** 分享出去的URL，需要拼接素食ID */
@property (copy,nonatomic) NSString *web_url;

/** 发布者的UID */
@property (copy,nonatomic) NSString *creater_id;
/** 发布者的昵称 */
@property (copy,nonatomic) NSString *creater_name;
/** 发布者的头像 */
@property (copy,nonatomic) NSString *creater_head;


@end
