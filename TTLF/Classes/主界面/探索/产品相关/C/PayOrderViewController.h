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

- (instancetype)initWithModel:(GoodsInfoModel *)model;

@end
