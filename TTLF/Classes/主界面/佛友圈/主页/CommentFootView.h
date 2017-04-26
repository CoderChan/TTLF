//
//  CommentFootView.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/30.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ClickType) {
    PresentCommentViewType, //立马评论
    PushToCommentControlerType // 去评论界面
};
@interface CommentFootView : UIView

/** 评论数 */
@property (assign,nonatomic) NSUInteger commentNum;

/** 点击弹出评论视图 */
@property (copy,nonatomic) void (^CommentBlock)(ClickType clickType);

@end
