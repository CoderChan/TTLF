//
//  PayOrderViewController.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/29.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

typedef NS_ENUM(NSInteger,PayType) {
    WechatPayType = 2,  // 微信支付
    AliPayType = 3  // 支付宝支付
};

@interface PayOrderViewController : SuperViewController


/**
 初始化

 @param model 商品模型
 @param isNewOrder 是否为新订单，如果不是，那就是待支付里过来的。发起支付时需要把之前的待支付订单删除。
 @return 当前对象
 */
- (instancetype)initWithModel:(GoodsInfoModel *)model OrderType:(BOOL)isNewOrder;

@end
