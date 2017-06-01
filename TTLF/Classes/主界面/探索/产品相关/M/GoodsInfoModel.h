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
@property (copy,nonatomic) NSString *goodID;
/** 商品名称 */
@property (copy,nonatomic) NSString *goods_name;
/** 商品封面 */
@property (copy,nonatomic) NSString *cover_img;
/** 商品状态：0、已下架  1、销售中  */
@property (assign,nonatomic) NSInteger status;
/** 是否推荐 */
@property (assign,nonatomic) BOOL is_recommend;
/** 图片集 */
@property (copy,nonatomic) NSArray *images;
/** 商品售价 */
@property (copy,nonatomic) NSString *sale_price;
/** 商品原价 */
@property (copy,nonatomic) NSString *original_price;
/** 产品规格参数,HTML文本信息 */
@property (copy,nonatomic) NSString *standard;
/** 其他说明 */
@property (copy,nonatomic) NSString *other_desc;
/** 淘宝链接 */
@property (copy,nonatomic) NSString *taobao_url;
/** 商品的分享页 */
@property (copy,nonatomic) NSString *web_url;

@end
