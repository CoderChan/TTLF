//
//  FlowerVaseModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/23.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlowerVaseModel : NSObject

/** 花瓶ID */
@property (copy,nonatomic) NSString *flower_id;
/** 花瓶图片地址 */
@property (copy,nonatomic) NSString *flower_img;
/** 花瓶名称 */
@property (copy,nonatomic) NSString *flower_name;

@end
