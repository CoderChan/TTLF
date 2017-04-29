//
//  NewsCommentModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/29.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsCommentModel : NSObject

/** 评论ID */
@property (copy,nonatomic) NSString *comment_id;
/** 评论者文字 */
@property (copy,nonatomic) NSString *comment_text;
/** 评论的图 */
@property (copy,nonatomic) NSString *comment_pic;
/** 评论时间 */
@property (assign,nonatomic) NSTimeInterval comment_time;
/** 评论者头像 */
@property (copy,nonatomic) NSString *commenter_head;
/** 评论者昵称 */
@property (copy,nonatomic) NSString *commenter_name;
/** 评论者ID */
@property (copy,nonatomic) NSString *commenter_uid;

@end
