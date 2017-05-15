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
@property (copy,nonatomic) NSString *place_id;
/** 景区名称 */
@property (copy,nonatomic) NSString *place_name;
/** 景区封面 */
@property (copy,nonatomic) NSString *place_img;
/** 景点攻略 */
@property (copy,nonatomic) NSString *place_travel;
/** 开放时间 */
@property (copy,nonatomic) NSString *open_time;
/** 联系电话 */
@property (copy,nonatomic) NSString *mobie;
/** 地址 */
@property (copy,nonatomic) NSString *address;
/** 门票 */
@property (copy,nonatomic) NSString *ticket;


@end
