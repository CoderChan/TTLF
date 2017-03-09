//
//  MineTableViewCell.h
//  FYQ
//
//  Created by Chan_Sir on 2017/2/25.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"

@interface MineTableViewCell : UITableViewCell

@property (strong,nonatomic) UserInfoModel *userModel;

+ (instancetype)sharedMineCell:(UITableView *)tableView;


@end
