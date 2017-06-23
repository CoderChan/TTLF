//
//  BookCommentModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/6/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookCommentModel : NSObject

// 佛典评论ID
@property (copy,nonatomic) NSString *comment_id;
// 佛典ID
@property (copy,nonatomic) NSString *book_id;
// 评论文字
@property (copy,nonatomic) NSString *book_comment;
// 评论者UID
@property (copy,nonatomic) NSString *creater_id;
// 评论者昵称
@property (copy,nonatomic) NSString *commenter_name;
// 评论者头像
@property (copy,nonatomic) NSString *commenter_head;
// 发布时间
@property (copy,nonatomic) NSString *create_time;

@end
