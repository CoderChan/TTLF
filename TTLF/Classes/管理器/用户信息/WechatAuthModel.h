//
//  WechatAuthModel.h
//  YLRM
//
//  Created by Chan_Sir on 2017/2/9.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>


/** 微信登录模型：access_token **/
@interface WechatAuthModel : NSObject

/** access_token */
@property (copy,nonatomic) NSString *access_token;
/** expires_in */
@property (copy,nonatomic) NSString *expires_in;
/** openid */
@property (copy,nonatomic) NSString *openid;
/** refresh_token */
@property (copy,nonatomic) NSString *refresh_token;
/** scope */
@property (copy,nonatomic) NSString *scope;
/** unionid */
@property (copy,nonatomic) NSString *unionid;

@end
