//
//  FindVageTableViewCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/29.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VegeInfoModel.h"


@interface FindVageTableViewCell : UITableViewCell

@property (strong,nonatomic) VegeInfoModel *vegeModel;

+ (instancetype)sharedFindVageCell:(UITableView *)tableView;

@end
