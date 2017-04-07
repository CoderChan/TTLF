//
//  NewsHeadView.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/4.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ClickType){
    UserClickType = 1,    // 点击自己头像和昵称
    GongdeClickType = 2,  // 点击查看功德值
    NewsClickType = 3     // 点击查看新闻资讯
};

/******** 首页的佛界头条 *********/
@interface NewsHeadView : UIView

/** 用户信息 */
@property (strong,nonatomic) UserInfoModel *userModel;
/** 点击的回调 */
@property (copy,nonatomic) void (^ClickBlock)(ClickType type);


@end
