//
//  ProvinceCityModel.h
//  FYQ
//
//  Created by Chan_Sir on 2017/2/27.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityInfoModel.h"

@interface ProvinceCityModel : NSObject

/** 省、直辖市、行政区 */
@property (copy,nonatomic) NSString *State;
/** 包含的市 */
@property (copy,nonatomic) NSArray *Cities;


@end
