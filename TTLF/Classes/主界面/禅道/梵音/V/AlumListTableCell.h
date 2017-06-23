//
//  AlumListTableCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/6/19.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlumListTableCell : UITableViewCell


@property (strong,nonatomic) AlbumInfoModel *model;

+ (instancetype)sharedAlumCell:(UITableView *)tableView;

@end
