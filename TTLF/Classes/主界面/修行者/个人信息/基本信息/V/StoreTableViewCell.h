//
//  StoreTableViewCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/21.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreTableViewCell : UITableViewCell

@property (strong,nonatomic) NewsArticleModel *newsModel;

+ (instancetype)sharedStoreTableCell:(UITableView *)tableView;

@end
