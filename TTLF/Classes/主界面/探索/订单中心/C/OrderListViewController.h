//
//  OrderListViewController.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface OrderListViewController : SuperViewController

- (instancetype)initWithOrderList:(NSArray *)orderArray;

@property (copy,nonatomic) void (^NewestOrderBlock)(NSArray *orderArray);

@end
