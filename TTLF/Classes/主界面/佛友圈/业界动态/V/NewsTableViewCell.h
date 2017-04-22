//
//  NewsTableViewCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/6.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsArticleModel.h"

@interface NewsTableViewCell : UITableViewCell

@property (strong,nonatomic) NewsArticleModel *model;

+ (instancetype)sharedNewsCell:(UITableView *)tableView;

@end
