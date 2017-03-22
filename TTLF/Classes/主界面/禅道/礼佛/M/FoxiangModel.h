//
//  FoxiangModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoxiangModel : NSObject

/** 佛像ID */
@property (copy,nonatomic) NSString *f_id;
/** 图标路径 */
@property (copy,nonatomic) NSString *url;
/** 名称 */
@property (copy,nonatomic) NSString *name;
/** 描述 */
@property (copy,nonatomic) NSString *desc;

@end
