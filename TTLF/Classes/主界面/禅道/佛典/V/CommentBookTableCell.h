//
//  CommentBookTableCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/6/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookCommentModel.h"

@interface CommentBookTableCell : UITableViewCell

// 佛典评论模型
@property (strong,nonatomic) BookCommentModel *model;

/** 点击头像和昵称的回调 */
@property (copy,nonatomic) void (^UserClickBlock)(BookCommentModel *commentModel);

+ (instancetype)sharedBoomCell:(UITableView *)tableView;

@end
