//
//  PunaNumListModel.h
//  FYQ
//
//  Created by Chan_Sir on 2017/3/10.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PunaNumListModel : NSObject

/** 变化值 */
@property (copy,nonatomic) NSString *option_value;
/** 时间 */
@property (assign,nonatomic) NSTimeInterval create_time;
/** 来源 */
@property (copy,nonatomic) NSString *option_type;

@end
