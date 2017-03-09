//
//  WechatInfoModel.h
//  YLRM
//
//  Created by Chan_Sir on 2017/2/9.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WechatInfoModel : NSObject

/** 普通用户的标识，对当前开发者帐号唯一 */
@property (copy,nonatomic) NSString *openid;
/** 普通用户昵称 */
@property (copy,nonatomic) NSString *nickname;
/** 性别 1为男性，2为女性 */
@property (assign,nonatomic) int sex;
/** 普通用户个人资料填写的省份 */
@property (copy,nonatomic) NSString *province;
/** 城市 */
@property (copy,nonatomic) NSString *city;
/** 国家 */
@property (copy,nonatomic) NSString *country;
/** 用户头像 */
@property (copy,nonatomic) NSString *headimgurl;
/** 用户特权信息，json数组，如微信沃卡用户为（chinaunicom） */
//@property (copy,nonatomic) NSDictionary *privilege;
/** 用户统一标识。针对一个微信开放平台帐号下的应用，同一用户的unionid是唯一的。 */
@property (copy,nonatomic) NSString *unionid;


@end
