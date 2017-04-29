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

@property (strong,nonatomic) NewsCommentModel *commentModel;

+ (instancetype)sharedCommentTableCell:(UITableView *)tableView;

@end
