//
//  AddressTableViewCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell

/** 线 */
@property (strong,nonatomic) UIImageView *xian;
/** 是否为默认地址 */
@property (strong,nonatomic) UIButton *defaultBtn;

/** 收货人名字 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 电话号码 */
@property (strong,nonatomic) UILabel *phoneLabel;
/** 详细地址 */
@property (strong,nonatomic) UILabel *addressLabel;



/** 地址模型 */
@property (strong,nonatomic) AddressModel *model;
/** 设置默认地址的回调 */
@property (copy,nonatomic) void (^SetDefaultBlock)(AddressModel *model);
/** 初始化 */
+ (instancetype)sharedAddressCell:(UITableView *)tableView;

@end
