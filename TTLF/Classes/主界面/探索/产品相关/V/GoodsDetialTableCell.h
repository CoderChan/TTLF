//
//  GoodsDetialTableCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/7/29.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetialTableCell : UITableViewCell

@property (strong,nonatomic) GoodsInfoModel *model;

+ (instancetype)sharedCell:(UITableView *)tableView;

@end
