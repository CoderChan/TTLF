//
//  LifoResourceModel.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/24.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "LifoResourceModel.h"
#import <MJExtension/MJExtension.h>

@implementation LifoResourceModel

+ (instancetype)mj_objectWithKeyValues:(id)keyValues
{
    if (![keyValues isKindOfClass:[NSDictionary class]]) return nil;
    LifoResourceModel *lifoModel = [super mj_objectWithKeyValues:keyValues];
    
    // 佛像
    NSMutableArray *array1 = [NSMutableArray array];
    NSArray *pusa = [lifoModel.pusa copy];
    for (NSDictionary *dic in pusa) {
        FoxiangModel *foxiangModel = [FoxiangModel mj_objectWithKeyValues:dic];
        [array1 addObject:foxiangModel];
    }
    lifoModel.pusa = array1;
    
    // 香
    NSMutableArray *array2 = [NSMutableArray array];
    NSArray *xiang = [lifoModel.xiang copy];
    for (NSDictionary *dic in xiang) {
        XiangModel *xiangModel = [XiangModel mj_objectWithKeyValues:dic];
        [array2 addObject:xiangModel];
    }
    lifoModel.xiang = array2;
    // 花瓶
    NSMutableArray *array3 = [NSMutableArray array];
    NSArray *flowers = [lifoModel.flowers copy];
    for (NSDictionary *dic in flowers) {
        FlowerVaseModel *flowerModel = [FlowerVaseModel mj_objectWithKeyValues:dic];
        [array3 addObject:flowerModel];
    }
    lifoModel.flowers = array3;
    // 果盘
    NSMutableArray *array4 = [NSMutableArray array];
    NSArray *furit = [lifoModel.furit copy];
    for (NSDictionary *dic in furit) {
        FruitBowlModel *fruitModel = [FruitBowlModel mj_objectWithKeyValues:dic];
        [array4 addObject:fruitModel];
    }
    lifoModel.furit = array4;
    // 佛牌
    NSMutableArray *array5 = [NSMutableArray array];
    NSArray *pai = [lifoModel.pai copy];
    for (NSDictionary *dic in pai) {
        FopaiModel *paiModel = [FopaiModel mj_objectWithKeyValues:dic];
        [array5 addObject:paiModel];
    }
    lifoModel.pai = array5;
    
    return lifoModel;
}

@end
