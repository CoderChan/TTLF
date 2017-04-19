//
//  CommentFootView.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/30.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentFootView : UIView

/** 点击弹出评论视图 */
@property (copy,nonatomic) void (^CommentBlock)();

@end
