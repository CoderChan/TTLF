//
//  SendDynHeadView.h
//  FYQ
//
//  Created by Chan_Sir on 2017/1/13.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SendDynHeadView : UIView

/** 图片 */
@property (strong,nonatomic) UIImageView *imageView;
/** 输入框 */
@property (strong,nonatomic) UITextView *textView;

@property (copy,nonatomic) void (^ImgClickBlock)();

@end
