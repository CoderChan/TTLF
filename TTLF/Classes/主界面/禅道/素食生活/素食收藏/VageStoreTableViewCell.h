//
//  VageStoreTableViewCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/6.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VegeInfoModel.h"

@interface VageStoreTableViewCell : UITableViewCell

@property (strong,nonatomic) VegeInfoModel *vegeModel;

+ (instancetype)sharedVageCell:(UITableView *)tableView;

@end
