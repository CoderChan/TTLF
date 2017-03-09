//
//  UserInfoModel.h
//  FYQ
//
//  Created by Chan_Sir on 2017/1/27.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

/** 用户ID */
@property (copy,nonatomic) NSString *userID;
/** 微信的标示ID */
@property (copy,nonatomic) NSString *unionid;
/** 在家还是出家 */
@property (assign,nonatomic) BOOL isOutHome;
/** 手机号码 */
@property (copy,nonatomic) NSString *phoneNum;
/** 昵称 */
@property (copy,nonatomic) NSString *nickName;
/** 生肖 */
@property (copy,nonatomic) NSString *animal;
/** 城市 */
@property (copy,nonatomic) NSString *city;
/** 性别 男1女2 */
@property (assign,nonatomic) int sex;
/** 功德值 */
@property (assign,nonatomic) float punnaNum;
/** 头像 */
@property (copy,nonatomic) NSString *headUrl;
/** 用户背景图片 */
@property (copy,nonatomic) NSString *userBgImg;
/** 注册时间 */
@property (copy,nonatomic) NSString *register_time;
/** 花名名称 */
@property (copy,nonatomic) NSString *stageName;
/** 花名图标地址 */
@property (copy,nonatomic) NSString *stageIcon;
/** 设备来源 */
@property (copy,nonatomic) NSString *from;



@end
