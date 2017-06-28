//
//  AlumListTableCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/6/19.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlumListTableCell : UITableViewCell

// 模型
@property (strong,nonatomic) AlbumInfoModel *model;

// 序号
@property (strong,nonatomic) UILabel *orderLabel;
// 名称
@property (strong,nonatomic) UILabel *nameLabel;

// 更多按钮
@property (strong,nonatomic) UIButton *button;

+ (instancetype)sharedAlumCell:(UITableView *)tableView;

@end
