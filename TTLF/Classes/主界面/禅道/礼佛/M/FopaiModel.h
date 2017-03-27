//
//  FopaiModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/23.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FopaiModel : NSObject

/** 佛牌ID */
@property (copy,nonatomic) NSString *pai_id;
/** 佛牌图标名称 */
@property (copy,nonatomic) NSString *fopai_img;
/** 佛牌名称 */
@property (copy,nonatomic) NSString *fopai_name;

@end
