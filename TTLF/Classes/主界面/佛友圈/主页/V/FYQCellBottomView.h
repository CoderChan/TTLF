//
//  FYQCellBottomView.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/14.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CellClickType) {
    ShareType = 1,    // 分享
    CommentType = 2,  // 评论
    ZanType = 3       // 点赞
};

@interface FYQCellBottomView : UIView

/** 点击回调 */
@property (copy,nonatomic) void (^ClickBlock)(CellClickType type);

@end
