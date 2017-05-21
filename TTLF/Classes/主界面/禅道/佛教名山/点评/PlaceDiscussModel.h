//
//  PlaceDiscussModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/19.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceDiscussModel : NSObject

/** 评论ID */
@property (copy,nonatomic) NSString *discuss_id;
/** 评论的文字内容 */
@property (copy,nonatomic) NSString *discuss_content;
/** 评论的图片地址 */
@property (copy,nonatomic) NSArray *scenic_img_desc;
/** 评论的时间 */
@property (copy,nonatomic) NSString *create_time;
/** 评论者的ID */
@property (copy,nonatomic) NSString *creater_id;
/** 评论者的昵称 */
@property (copy,nonatomic) NSString *creater_name;
/** 评论者的头像 */
@property (copy,nonatomic) NSString *creater_head;

@end
