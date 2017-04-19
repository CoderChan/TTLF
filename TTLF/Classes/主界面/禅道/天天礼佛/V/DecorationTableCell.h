//
//  DecorationTableCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/23.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DecorationTableCell : UITableViewCell

/** 花瓶 */
@property (strong,nonatomic) FlowerVaseModel *flowerModel;
/** 香 */
@property (strong,nonatomic) XiangModel *xiangModel;
/** 果盘 */
@property (strong,nonatomic) FruitBowlModel *fruitModel;

/** 初始化 */
+ (instancetype)sharedDecorationCell:(UITableView *)tableView;

@end
