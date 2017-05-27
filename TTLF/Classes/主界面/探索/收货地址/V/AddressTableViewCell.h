//
//  AddressTableViewCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell

/** 地址模型 */
@property (strong,nonatomic) AddressModel *model;
/** 设置默认地址的回调 */
@property (copy,nonatomic) void (^SetDefaultBlock)(AddressModel *model);
/** 初始化 */
+ (instancetype)sharedAddressCell:(UITableView *)tableView;

@end
