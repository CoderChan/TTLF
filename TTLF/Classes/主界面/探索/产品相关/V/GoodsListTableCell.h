//
//  GoodsListTableCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

/******* 商品分类的cell *******/
@interface GoodsListTableCell : UITableViewCell

/** 商品分类模型 */
@property (strong,nonatomic) GoodsClassModel *cateModel;
/** 初始化 */
+ (instancetype)sharedGoodsListTableCell:(UITableView *)tableView;

@end
