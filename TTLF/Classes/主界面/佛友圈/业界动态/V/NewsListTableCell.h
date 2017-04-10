//
//  NewsListTableCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/10.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsArticleModel.h"

@interface NewsListTableCell : UITableViewCell

@property (strong,nonatomic) NewsArticleModel *model;

+ (instancetype)sharedNewsListTableCell:(UITableView *)tableView;

@end
