//
//  OrderDetialViewController.m
//  TTLF
//
//  Created by YRJSB on 2017/8/18.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "OrderDetialViewController.h"

@interface OrderDetialViewController ()

/**
 数据源
 */
@property (strong, nonatomic) GoodsOrderModel *model;
/**
 数组
 */
@property (strong, nonatomic) NSArray *array;
/**
 表格
 */
@property (strong, nonatomic) UITableView *tableView;


@end

@implementation OrderDetialViewController

- (instancetype)initWithModel:(GoodsOrderModel *)orderModel
{
    self = [super init];
    if (self) {
        self.model = orderModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    // 商品详情
    // 收货地址
    // 是爱丽丝
}



@end
