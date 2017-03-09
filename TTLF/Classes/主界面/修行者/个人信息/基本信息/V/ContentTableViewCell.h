//
//  ContentTableViewCell.h
//  FYQ
//
//  Created by Chan_Sir on 2017/1/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentTableViewCell : UITableViewCell

@property (strong,nonatomic) UILabel *contentLabel;

+ (instancetype)sharedContentTableCell:(UITableView *)tableView;

@end
