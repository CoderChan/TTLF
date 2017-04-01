//
//  SendCommentView.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/31.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendCommentView : UIView

/** 弹出选择图片控制器 */
@property (copy,nonatomic) void (^SelectImageBlock)();
/** 是否附带图 */
@property (assign,nonatomic) BOOL isSendIcon;
/** 评论附带的图 */
@property (strong,nonatomic) UIImageView *commentImgView;

- (void)hidHub;

@end
