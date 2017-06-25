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
@property (strong,nonatomic) BookCommentModel *bookCommentModel;
// 梵音评论模型
@property (strong,nonatomic) MusicCommentModel *musciCommentModel;

/** 点击头像和昵称的回调 */
@property (copy,nonatomic) void (^UserClickBookBlock)(BookCommentModel *commentModel);
@property (copy,nonatomic) void (^UserClickMusicBlock)(MusicCommentModel *commentModel);

+ (instancetype)sharedBoomCell:(UITableView *)tableView;

@end
