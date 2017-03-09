//
//  ProvinceCityModel.m
//  FYQ
//
//  Created by Chan_Sir on 2017/2/27.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "ProvinceCityModel.h"
#import <MJExtension/MJExtension.h>

@implementation ProvinceCityModel

+ (NSMutableArray *)mj_objectArrayWithKeyValuesArray:(id)keyValuesArray
{
    if (![keyValuesArray isKindOfClass:[NSArray class]]) return nil;
    NSMutableArray *modelArray = [super mj_objectArrayWithKeyValuesArray:keyValuesArray];
    for (ProvinceCityModel *model in modelArray) {
        NSMutableArray *array1 = [NSMutableArray array];
        
        NSArray *result1 = [model.Cities copy];
        for (NSDictionary *dic in result1) {
            CityInfoModel *contacts = [CityInfoModel mj_objectWithKeyValues:dic];
            
            [array1 addObject:contacts];
        }
        model.Cities = array1;
    }
    
    return modelArray;
    
}

//- (void)setValue:(id)value forUndefinedKey:(NSString *)key
//{
//    
//}
//
@end
