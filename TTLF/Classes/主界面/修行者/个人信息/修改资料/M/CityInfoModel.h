//
//  CityInfoModel.h
//  FYQ
//
//  Created by Chan_Sir on 2017/2/27.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityInfoModel : NSObject

/** 市名 */
@property (copy,nonatomic) NSString *city;
/** 经度 */
@property (copy,nonatomic) NSString *lat;
/** 维度 */
@property (copy,nonatomic) NSString *lon;


@end
