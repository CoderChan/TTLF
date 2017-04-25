//
//  SendCommentView.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/31.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SendCommentDelegate <NSObject>

- (void)sendCommentWithImage:(UIImage *)image CommentText:(NSString *)commentText;

@end

@interface SendCommentView : UIView

/** 弹出选择图片控制器 */
@property (copy,nonatomic) void (^SelectImageBlock)();
/** 是否附带图 */
@property (assign,nonatomic) BOOL isSendIcon;
/** 评论附带的图 */
@property (strong,nonatomic) UIImageView *commentImgView;

/** 发表评论的代理 */
@property (weak,nonatomic) id<SendCommentDelegate> delegate;

- (void)hidHub;


@end
