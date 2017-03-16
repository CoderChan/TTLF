//
//  PunnaListTableCell.h
//  FYQ
//
//  Created by Chan_Sir on 2017/3/10.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PunaNumListModel.h"

@interface PunnaListTableCell : UITableViewCell

@property (strong,nonatomic) PunaNumListModel *model;

+ (instancetype)sharedPunnaListTableCell:(UITableView *)tableView;

@end
