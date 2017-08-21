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
// 状态(-1：取消订单；0：待支付；1：已支付，准备发货；2：商品运输中；3：已完成。)
@property (assign,nonatomic) int status;
// 数量
@property (assign,nonatomic) int num;
// 购买时的价格
@property (copy,nonatomic) NSString *price;
// 备注
@property (copy,nonatomic) NSString *remark;
// 操作时间
@property (copy,nonatomic) NSString *status_time;
// 确认日期
@property (copy,nonatomic) NSString *check_time;
/** 物流商家 */
@property (copy, nonatomic) NSString *wuliu_type;
/** 物流订单号 */
@property (copy, nonatomic) NSString *wuliu_order;
/** 地址 */
@property (strong, nonatomic) AddressModel *address;

// 商品详情
@property (strong,nonatomic) GoodsInfoModel *goods;

@end
