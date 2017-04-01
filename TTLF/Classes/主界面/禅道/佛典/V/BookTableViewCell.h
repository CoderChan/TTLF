//
//  BookTableViewCell.h
//  BookStore
//
//  Created by Chan_Sir on 16/3/21.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookTableViewCell : UITableViewCell


/** 初始化书架 */
+ (instancetype)sharedBookTableViewCell:(UITableView *)tableView;
@end
