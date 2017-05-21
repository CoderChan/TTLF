//
//  AreaListModel.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/19.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AreaListModel.h"
#import <MJExtension/MJExtension.h>

@implementation AreaListModel

+ (instancetype)mj_objectWithKeyValues:(id)keyValues
{
    if (![keyValues isKindOfClass:[NSDictionary class]]) return nil;
    AreaListModel *model = [super mj_objectWithKeyValues:keyValues];
    // 直辖市
    NSMutableArray *zhixiashiArray = [NSMutableArray new];
    NSArray *result1 = [model.zhixiashi copy];
    for (NSDictionary *dic in result1) {
        AreaDetialModel *model1 = [AreaDetialModel mj_objectWithKeyValues:dic];
        
        [zhixiashiArray addObject:model1];
    }
    model.zhixiashi = zhixiashiArray;
    // 海外地区
    NSMutableArray *haiwaiArray = [NSMutableArray new];
    NSArray *result2 = [model.haiwai copy];
    for (NSDictionary *dic in result2) {
        AreaDetialModel *model2 = [AreaDetialModel mj_objectWithKeyValues:dic];
        
        [haiwaiArray addObject:model2];
    }
    model.haiwai = haiwaiArray;
    // 港澳台
    NSMutableArray *gangArray = [NSMutableArray new];
    NSArray *result3 = [model.gangaotai copy];
    for (NSDictionary *dic in result3) {
        AreaDetialModel *model3 = [AreaDetialModel mj_objectWithKeyValues:dic];
        
        [gangArray addObject:model3];
    }
    model.gangaotai = gangArray;
    // 省
    NSMutableArray *shengArray = [NSMutableArray new];
    NSArray *result4 = [model.sheng copy];
    for (NSDictionary *dic in result4) {
        AreaDetialModel *model4 = [AreaDetialModel mj_objectWithKeyValues:dic];
        
        [shengArray addObject:model4];
    }
    model.sheng = shengArray;
    // 自治区
    NSMutableArray *zizhiquArray = [NSMutableArray new];
    NSArray *result5 = [model.zizhiqu copy];
    for (NSDictionary *dic in result5) {
        AreaDetialModel *model5 = [AreaDetialModel mj_objectWithKeyValues:dic];
        
        [zizhiquArray addObject:model5];
    }
    model.zizhiqu = zizhiquArray;
    
    return model;
}

@end
