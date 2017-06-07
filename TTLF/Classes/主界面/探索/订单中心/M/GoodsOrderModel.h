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

/** 商品ID */
@property (copy,nonatomic) NSString *goodID;
/** 商品名称 */
@property (copy,nonatomic) NSString *goods_name;
/** 商品状态：1、待付款  2、订单已收到 3、运输中 4、已收货 */
@property (assign,nonatomic) NSInteger status;
/** 物流ID */
@property (copy,nonatomic) NSString *floID;
/** 图片集 */
@property (copy,nonatomic) NSArray *images;
/** 商品售价 */
@property (copy,nonatomic) NSString *sale_price;
/** 商品原价 */
@property (copy,nonatomic) NSString *original_price;
/** 商品描述，对名称的描述 */
@property (copy,nonatomic) NSString *desc;
/** 产品规格参数 */
@property (copy,nonatomic) NSString *standard;
/** 淘宝链接 */
@property (copy,nonatomic) NSString *taobao_url;
/** 商品的分享页 */
@property (copy,nonatomic) NSString *web_url;

@end
