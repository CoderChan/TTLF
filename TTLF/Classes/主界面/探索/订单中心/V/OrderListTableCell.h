//
//  OrderListTableCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

/********* 商品订单的cell *********/
@interface OrderListTableCell : UITableViewCell

@property (strong,nonatomic) GoodsOrderModel *model;

+ (instancetype)sharedOrderListCell:(UITableView *)tableView;

@end
