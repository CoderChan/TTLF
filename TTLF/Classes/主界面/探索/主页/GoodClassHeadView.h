//
//  GoodClassHeadView.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodClassHeadView : UIView
// 点击事件
@property (copy,nonatomic) void (^DidClickBlock)();
// 推荐的商品
@property (strong,nonatomic) GoodsInfoModel *model;

@end
