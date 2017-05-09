//
//  RightMoreView.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/21.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MoreItemClickType){
    WechatFriendType = 1, // 微信好友
    WechatQuanType = 2, // 微信朋友圈
    StoreClickType = 3, // 添加收藏
    QQFriendType = 4, // QQ好友分享
    QQSpaceType = 5, // QQ空间分享
    OpenAtSafariType = 6, // 在Safari中打开
    SystermShareType = 7,  // 系统分享
    CopyUrlType = 8,   // 复制链接
    RefreshType = 9,   // 刷新
    StopLoadType = 10   // 停止加载
};

@protocol RightMoreViewDelegate <NSObject>

- (void)rightMoreViewWithClickType:(MoreItemClickType)clickType;

@end

@interface RightMoreView : UIView

/** 点击事件的代理 */
@property (weak,nonatomic) id<RightMoreViewDelegate> delegate;
/** 文字描述 */
@property (strong,nonatomic) NSString *title;

@end
