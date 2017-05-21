//
//  PlaceTableViewCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/25.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceDetialModel.h"

@interface PlaceTableViewCell : UITableViewCell

/** 景区详情模型 */
@property (strong,nonatomic) PlaceDetialModel *placeModel;
/** 初始化 */
+ (instancetype)sharedDisCoverTableCell:(UITableView *)tableView;


@end
