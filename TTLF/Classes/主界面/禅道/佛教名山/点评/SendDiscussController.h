//
//  SendDiscussController.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface SendDiscussController : SuperViewController

/** 初始化 */
- (instancetype)initWithModel:(PlaceDetialModel *)placeModel;
/** 发布成功后的回调 */
@property (copy,nonatomic) void (^AddCommentBlock)(PlaceDiscussModel *discussModel);


@end
