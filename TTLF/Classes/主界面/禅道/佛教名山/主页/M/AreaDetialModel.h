//
//  AreaDetialModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/19.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaDetialModel : NSObject

/** 地区ID */
@property (copy,nonatomic) NSString *id;
/** 地区名称 */
@property (copy,nonatomic) NSString *province_name;
/** 地区图标 */
@property (copy,nonatomic) NSString *province_img;
/** 所属区域 */
@property (copy,nonatomic) NSString *areas;

@end
