//
//  WechatPayInfoModel.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WechatPayInfoModel : NSObject

// 应用ID
@property (copy,nonatomic) NSString *appid;
// 随机字符串
@property (copy,nonatomic) NSString *noncestr;
// 扩展字段
@property (copy,nonatomic) NSString *package;
// 预支付交易会话ID
@property (copy,nonatomic) NSString *prepayid;
// 商户号
@property (copy,nonatomic) NSString *partnerid;
// 时间戳
@property (copy,nonatomic) NSString *timestamp;
// 签名
@property (copy,nonatomic) NSString *sign;
//
@property (copy,nonatomic) NSString *packagestr;
// 订单号，根据这个可以查询支付结果
@property (copy,nonatomic) NSString *out_trade_no;

@end
