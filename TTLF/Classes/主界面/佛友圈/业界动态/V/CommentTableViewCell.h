//
//  CommentTableViewCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsCommentModel.h"

/*********** 评论的cell ************/
@interface CommentTableViewCell : UITableViewCell

/** 评论模型 */
@property (strong,nonatomic) NewsCommentModel *commentModel;
/** 点击头像和昵称的回调 */
@property (copy,nonatomic) void (^UserClickBlock)(NewsCommentModel *commentModel);
/** 初始化 */
+ (instancetype)sharedCommentTableCell:(UITableView *)tableView;

@end
