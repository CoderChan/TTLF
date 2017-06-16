//
//  MyBooksTableViewCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/2.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBooksTableViewCell : UITableViewCell

@property (strong,nonatomic) BookInfoModel *model;

/** 初始化书架 */
+ (instancetype)sharedBookTableViewCell:(UITableView *)tableView;

@end
