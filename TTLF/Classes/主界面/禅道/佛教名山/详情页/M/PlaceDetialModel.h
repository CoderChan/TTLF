//
//  PlaceDetialModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/14.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceDetialModel : NSObject

/** 景区ID */
@property (copy,nonatomic) NSString *scenic_id;
/** 景区名称 */
@property (copy,nonatomic) NSString *scenic_name;
/** 区域ID */
@property (copy,nonatomic) NSString *areas;
/** 景区封面 */
@property (copy,nonatomic) NSString *scenic_img;
/** 景点攻略 */
@property (copy,nonatomic) NSString *strategy;
/** 开放时间 */
@property (copy,nonatomic) NSString *open_time;
/** 分享链接 */
@property (copy,nonatomic) NSString *web_url;
/** 联系电话 */
@property (copy,nonatomic) NSString *scenic_phone;
/** 地址 */
@property (copy,nonatomic) NSString *scenic_address;
/** 交通攻略 */
@property (copy,nonatomic) NSString *traic;
/** 门票 */
@property (copy,nonatomic) NSString *scenic_ticket;


@end
