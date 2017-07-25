//
//  GoodsInfoModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/25.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

/********** 单个商品的信息模型 ************/
@interface GoodsInfoModel : NSObject

/** 商品ID */
@property (copy,nonatomic) NSString *goods_id;
/** 商品名称 */
@property (copy,nonatomic) NSString *goods_name;
/** 商品描述名称 */
@property (copy,nonatomic) NSString *goods_name_desc;
/** 产品规格-富文本 */
@property (copy,nonatomic) NSString *standard;
/** 售价 */
@property (copy,nonatomic) NSString *sale_price;
/** 原价 */
@property (copy,nonatomic) NSString *original_price;
/** 商品说明 */
@property (copy,nonatomic) NSString *goods_desc;
/** 分享页 */
@property (copy,nonatomic) NSString *web_url;
/** 封面的地址 */
@property (copy,nonatomic) NSString *goods_logo;
/** 淘宝链接 */
@property (copy,nonatomic) NSString *taobao_url;
/** 是否推荐 */
@property (assign,nonatomic) BOOL is_recommend;
/** 轮播图 */
@property (copy,nonatomic) NSArray *carousel;

@end
