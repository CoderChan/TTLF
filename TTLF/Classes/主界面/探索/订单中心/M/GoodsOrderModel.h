//
//  GoodsOrderModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/25.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

/********** 商品订单的模型 **********/
@interface GoodsOrderModel : NSObject
// 订单ID
@property (copy,nonatomic) NSString *order_id;
// 商品ID
@property (copy,nonatomic) NSString *goods_id;
// 订单号
@property (copy,nonatomic) NSString *ordernum;
// 开单用户
@property (copy,nonatomic) NSString *uid;
// 状态
@property (assign,nonatomic) int status;
// 数量
@property (assign,nonatomic) int num;
// 购买时的价格
@property (copy,nonatomic) NSString *price;
// 备注
@property (copy,nonatomic) NSString *remark;
// 操作时间
@property (copy,nonatomic) NSString *status_time;
// check_time
@property (copy,nonatomic) NSString *check_time;

// 商品详情
@property (strong,nonatomic) GoodsInfoModel *goods;

@end
