//
//  OrderDetialViewController.h
//  TTLF
//
//  Created by YRJSB on 2017/8/18.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface OrderDetialViewController : SuperViewController


/**
 初始化OrderDetialViewController对象

 @param orderModel 名单模型
 @return OrderDetialViewController对象
 */
- (instancetype)initWithModel:(GoodsOrderModel *)orderModel;

@end
