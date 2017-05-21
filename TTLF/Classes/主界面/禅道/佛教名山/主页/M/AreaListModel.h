//
//  AreaListModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/19.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AreaDetialModel.h"

@interface AreaListModel : NSObject

/** 自治区 */
@property (copy,nonatomic) NSArray *zhixiashi;
/** 港澳台 */
@property (copy,nonatomic) NSArray *gangaotai;
/** 海外地区 */
@property (copy,nonatomic) NSArray *haiwai;
/** 省 */
@property (copy,nonatomic) NSArray *sheng;
/** 自治区 */
@property (copy,nonatomic) NSArray *zizhiqu;

@end
