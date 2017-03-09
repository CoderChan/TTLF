//
//  SharedView.h
//  FYQ
//
//  Created by Chan_Sir on 2017/1/10.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,ShareToAPPType) {
    WechatFriender, // 微信好友
    WechatFBAA,    // 微信朋友圈
    QQFriend,     // QQ好友
    QQFBAA       // QQ空间
};

@interface SharedView : UIView

- (instancetype)initWithFrame:(CGRect)frame ShareClick:(void (^)(ShareToAPPType shareType))shareBlock;


@end
