//
//  AllUserTableViewCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/7/4.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllUserModel.h"

@interface AllUserTableViewCell : UITableViewCell

@property (strong,nonatomic) AllUserModel *model;


+ (instancetype)sharedCell:(UITableView *)tableView;

@end
