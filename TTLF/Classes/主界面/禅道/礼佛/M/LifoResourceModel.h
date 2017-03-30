//
//  LifoResourceModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/24.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoxiangModel.h"
#import "FlowerVaseModel.h"
#import "XiangModel.h"
#import "FruitBowlModel.h"
#import "FopaiModel.h"

@interface LifoResourceModel : NSObject

/** 菩萨 */
@property (copy,nonatomic) NSArray *pusa;
/** 花瓶 */
@property (copy,nonatomic) NSArray *flowers;
/** 果盘 */
@property (copy,nonatomic) NSArray *furit;
/** 香 */
@property (copy,nonatomic) NSArray *xiang;
/** 佛牌 */
@property (copy,nonatomic) NSArray *pai;

@end


