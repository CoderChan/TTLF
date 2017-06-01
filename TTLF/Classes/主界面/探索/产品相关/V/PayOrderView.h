//
//  PayOrderView.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/26.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsInfoModel.h"

/********* 支付视图 *********/

@interface PayOrderView : UIView

/** 立即购买单个商品的模型 */
@property (strong,nonatomic) GoodsInfoModel *goodsModel;

@end
