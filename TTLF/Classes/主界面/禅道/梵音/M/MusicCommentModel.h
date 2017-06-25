//
//  MusicCommentModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/6/24.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicCommentModel : NSObject

// 评论ID
@property (copy,nonatomic) NSString *comment_id;
// 梵音ID
@property (copy,nonatomic) NSString *music_id;
// 评论文字
@property (copy,nonatomic) NSString *music_comment;
// 评论者ID
@property (copy,nonatomic) NSString *commenter_head;
// 评论者头像
@property (copy,nonatomic) NSString *commenter_name;
// 评论者时间
@property (copy,nonatomic) NSString *create_time;
// 创建时间
@property (copy,nonatomic) NSString *creater_id;

@end
