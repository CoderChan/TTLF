//
//  PlaceDiscussTableCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceDiscussModel.h"

@interface PlaceDiscussTableCell : UITableViewCell


/** 评论模型 */
@property (strong,nonatomic) PlaceDiscussModel *discussModel;
/** 点击头像前往功德值界面 */
@property (copy,nonatomic) void (^ClickUserBlock)(NSString *userID);
/** 初始化 */
+ (instancetype)sharedDiscussCell:(UITableView *)tableView;

@end
