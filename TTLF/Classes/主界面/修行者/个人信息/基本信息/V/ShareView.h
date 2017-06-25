//
//  ShareView.h
//  TTLF
//
//  Created by Chan_Sir on 2017/6/24.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ShareViewClickType){
    WechatFriendType = 1, // 微信好友
    WechatQuanType = 2, // 微信朋友圈
    QQFriendType = 3, // QQ好友分享
    QQSpaceType = 4, // QQ空间分享
    SinaShareType = 5, // 新浪微博
    SysterShareType = 6,  // 系统分享
    WechatStoreType = 7  // 微信收藏
};

@protocol ShareViewDelegate <NSObject>

- (void)shareViewClickWithType:(ShareViewClickType)type;

@end

@interface ShareView : UIView

@property (weak,nonatomic) id<ShareViewDelegate> delegate;

@end
