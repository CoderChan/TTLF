//
//  NewsListTableCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/10.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsArticleModel.h"

/********* 之前版本的文字头条HeadView *********/
@interface NewsListTableCell : UITableViewCell

/** 新闻文章模型 */
@property (strong,nonatomic) NewsArticleModel *model;
/** 初始化 */
+ (instancetype)sharedNewsListTableCell:(UITableView *)tableView;

@end
