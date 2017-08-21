//
//  GoodsOrderModel.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/25.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "GoodsOrderModel.h"
#import <MJExtension/MJExtension.h>

@implementation GoodsOrderModel

+ (instancetype)mj_objectWithKeyValues:(id)keyValues
{
    if (![keyValues isKindOfClass:[NSDictionary class]]) return nil;
    
    GoodsOrderModel *orderModel = [super mj_objectWithKeyValues:keyValues];
    
    NSDictionary *goods = [keyValues objectForKey:@"goods"];
    orderModel.goods = [GoodsInfoModel mj_objectWithKeyValues:goods];
    
    NSDictionary *address = [keyValues objectForKey:@"address"];
    orderModel.address = [AddressModel mj_objectWithKeyValues:address];
    
    return orderModel;
}


@end
