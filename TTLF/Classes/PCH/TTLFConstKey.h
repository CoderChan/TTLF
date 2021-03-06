//
//  TTLFConstKey.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/************  通知及监听 关键字  *****************/
#define YLNotificationCenter [NSNotificationCenter defaultCenter]


/********* NSUserDefault 关键字 **********/
extern NSString *const isFirstComeIn; // 第一次进来展示引导指标
extern NSString *const CFBundleVersion; // 版本号
extern NSString *const HowToUse; // 怎么使用
extern NSString *const LastPusaImgURL; // 上一次礼佛的佛像图片地址
extern NSString *const LastMusicID; // 上一次播放音乐的ID
extern NSString *const LastMusicCateID; // 上一次选中的梵音分类ID
extern NSString *const LastMusicIndex; // 上一次选中的索引
extern NSString *const OrderListChanged; // 订单列表数据有变化
extern NSString *const DeleteUnPayOrderNoti; // 删除未支付订单通知



extern NSString *const UuserID; // 用户ID
extern NSString *const Uunionid; // 微信标识ID
extern NSString *const Utype; // 用户身份类型
extern NSString *const UisOutHome; // 是否皈依
extern NSString *const UphoneNum; // 电话号码
extern NSString *const UnickName; // 昵称
extern NSString *const Uanimal; //  生肖
extern NSString *const Ucity; // 城市
extern NSString *const Usex; // 性别
extern NSString *const UpunnaNum;  // 功德值
extern NSString *const UheadUrl;  // 头像地址
extern NSString *const UregisterTime;  // 注册时间
extern NSString *const UstageName;  // 花名名称
extern NSString *const UstageIcon;  //  花名图标
extern NSString *const Ufrom;  //  设备来源
extern NSString *const UuserBgImg; //  背景图片

/********** 通知关键字 ***********/
extern NSString *const CreateNewVegeNoti; // 新发布了素食的通知
extern NSString *const WechatPayResultNoti; // 微信支付回调
extern NSString *const PaySuccessNoti; // 支付成功通知
extern NSString *const PayFailedNoti; // 支付失败通知


NS_ASSUME_NONNULL_END

