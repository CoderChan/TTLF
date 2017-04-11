//
//  DynamicModel.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/11.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "DynamicModel.h"
#import <MJExtension/MJExtension.h>

@implementation DynamicModel

+ (instancetype)mj_objectWithKeyValues:(id)keyValues
{
    DynamicModel *model = [super mj_objectWithKeyValues:keyValues];
    
    return model;
}

@end
