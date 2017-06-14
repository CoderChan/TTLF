//
//  BookStoreTableViewCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/2.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookStoreTableViewCell : UITableViewCell

@property (strong,nonatomic) BookInfoModel *model;

+ (instancetype)sharedBookStoreCell:(UITableView *)tableView;

@end
