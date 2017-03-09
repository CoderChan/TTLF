//
//  TitleTableCell.h
//  FYQ
//
//  Created by Chan_Sir on 2017/1/7.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleTableCell : UITableViewCell

@property (strong,nonatomic) UILabel *label;

+ (instancetype)sharedTitleTableCell:(UITableView *)tableView;

@end
