//
//  MyVageTableViewCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/7.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VegeInfoModel.h"

@interface MyVageTableViewCell : UITableViewCell

@property (strong,nonatomic) VegeInfoModel *vegeModel;

+ (instancetype)shardMyVageCell:(UITableView *)tableView;

@end
