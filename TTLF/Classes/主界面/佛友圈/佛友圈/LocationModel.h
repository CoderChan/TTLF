//
//  LocationModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/10.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationModel : NSObject

/** 地理位置 */
@property (copy,nonatomic) NSString *address;
/** 维度 */
@property (copy,nonatomic) NSString *latitude;
/** 经度 */
@property (copy,nonatomic) NSString *longitude;

@end
