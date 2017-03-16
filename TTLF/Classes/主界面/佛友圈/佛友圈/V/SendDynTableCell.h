//
//  SendDynTableCell.h
//  FYQ
//
//  Created by Chan_Sir on 2017/3/1.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendDynTableCell : UITableViewCell

/** 图标 */
@property (strong,nonatomic) UIImageView *iconView;
/** 标题 */
@property (strong,nonatomic) UILabel *titleLabel;
/** 内容 */
@property (strong,nonatomic) UILabel *contentLabel;


+ (instancetype)sharedSendDynTableCell:(UITableView *)tableView;

@end
