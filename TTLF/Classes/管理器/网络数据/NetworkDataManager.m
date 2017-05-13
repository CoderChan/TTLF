//
//  NetworkDataManager.m
//  FYQ
//
//  Created by Chan_Sir on 2017/2/6.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "NetworkDataManager.h"
#import <MJExtension/MJExtension.h>
#import "UserInfoManager.h"
#import "AccountTool.h"


@implementation NetworkDataManager

+ (instancetype)sharedManager
{
    static NetworkDataManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}


#pragma mark - 手机号码、微信注册登录
// 手机注册
- (void)registerByPhone:(NSString *)phoneNum Pass:(NSString *)passNum Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    NSString *url = @"http://app.yangruyi.com/home/Index/phoneRegister";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:phoneNum.base64EncodedString forKey:@"phone"];
    [param setValue:passNum.base64EncodedString forKey:@"pass"];
    [param setValue:@"8".base64EncodedString forKey:@"from"];
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/phoneRegister?phone=%@&pass=%@&from=%@",phoneNum.base64EncodedString,passNum.base64EncodedString,@"8".base64EncodedString];
    NSLog(@"手机注册url = %@",allurl);
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        NSLog(@"注册后的信息 = %@",responseObject);
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            UserInfoModel *userModel = [UserInfoModel mj_objectWithKeyValues:result];
            [self saveUserInfo:userModel Success:^{
                success();
            } Fail:^(NSString *errorMsg) {
                fail(errorMsg);
            }];
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

// 手机登录
- (void)loginByPhone:(NSString *)phoneNum Pass:(NSString *)passNum Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    NSString *url = @"http://app.yangruyi.com/home/Index/phoneLogin";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:phoneNum.base64EncodedString forKey:@"phone"];
    [param setValue:passNum.base64EncodedString forKey:@"pass"];
    [param setValue:@"8".base64EncodedString forKey:@"from"];
    
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/phoneLogin?phone=%@&pass=%@&from=%@",phoneNum.base64EncodedString,passNum.base64EncodedString,@"8".base64EncodedString];
    NSLog(@"手机登录url = %@",allurl);
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        NSLog(@"手机登录的信息 = %@",responseObject);
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            UserInfoModel *userModel = [UserInfoModel mj_objectWithKeyValues:result];
            [self saveUserInfo:userModel Success:^{
                success();
            } Fail:^(NSString *errorMsg) {
                fail(errorMsg);
            }];
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

// 忘记密码，设置新密码
- (void)setNewPassWord:(NSString *)phoneNum Pass:(NSString *)newPass Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    
    NSString *url = @"http://app.yangruyi.com/home/Index/forgetPass";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:phoneNum.base64EncodedString forKey:@"phone"];
    [param setValue:newPass.base64EncodedString forKey:@"newPass"];
    
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/forgetPass?phone=%@&newPass=%@",phoneNum.base64EncodedString,newPass.base64EncodedString];
    NSLog(@"忘记密码的url = %@",allurl);
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        NSLog(@"忘记密码的返回 = %@",responseObject);
        if (code == 1) {
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

// 微信注册登录相关
- (void)wechatLoginResponse:(SendAuthResp *)response Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    if (response.errCode == 0) {
        // 授权成功，拿到了code
        
        NSString *authUrl =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeChatAppID,WeChatAppKey,response.code];
        [HTTPManager GET:authUrl params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            KGLog(@"微信授权信息 = %@",responseObject);
            WechatAuthModel *authModel = [WechatAuthModel mj_objectWithKeyValues:responseObject];
            
            NSString *infoUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",authModel.access_token,authModel.openid];
            [HTTPManager GET:infoUrl params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                
                WechatInfoModel *wechatInfoModel = [WechatInfoModel mj_objectWithKeyValues:responseObject];
                // 通过微信注册
                [self registerWithWechatInfoModel:wechatInfoModel Success:^{
                    success();
                } Fail:^(NSString *errorMsg) {
                    fail(errorMsg);
                }];
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                fail(error.localizedDescription);
            }];
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            fail(error.localizedDescription);
        }];
    }else{
        // 授权失败
        fail(@"授权失败，请检查重试！");
    }
}

- (void)registerWithWechatInfoModel:(WechatInfoModel *)wechatInfoModel Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    NSString *url = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/wechatRegister"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:wechatInfoModel.nickname.base64EncodedString forKey:@"nickName"];
    [param setValue:wechatInfoModel.unionid.base64EncodedString forKey:@"unionid"];
    [param setValue:[NSString stringWithFormat:@"%d",wechatInfoModel.sex].base64EncodedString forKey:@"sex"];
    [param setValue:wechatInfoModel.headimgurl.base64EncodedString forKey:@"headUrl"];
    [param setValue:wechatInfoModel.city.base64EncodedString forKey:@"city"];
    [param setValue:@"8".base64EncodedString forKey:@"from"];
    
    NSString *getUrl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/register?nickName=%@&unionid=%@&sex=%@&headUrl=%@&city=%@&from=%@",wechatInfoModel.nickname.base64EncodedString,wechatInfoModel.unionid.base64EncodedString,[NSString stringWithFormat:@"%d",wechatInfoModel.sex].base64EncodedString,wechatInfoModel.headimgurl.base64EncodedString,wechatInfoModel.city.base64EncodedString,@"7".base64EncodedString];
    NSLog(@"微信注册登录url = %@",getUrl);
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        KGLog(@"微信登录返回的信息 = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            UserInfoModel *userModel = [UserInfoModel mj_objectWithKeyValues:result];
            [self saveUserInfo:userModel Success:^{
                success();
            } Fail:^(NSString *errorMsg) {
                fail(errorMsg);
            }];
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}

// 退出登录
- (void)returnAccountSuccess:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/phoneLogOut"];
    
    [HTTPManager POST:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            [self reloginCompletion:^{
               success();
            }];
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

// 退出登录，清除一些缓存
- (void)reloginCompletion:(void (^)())completion
{
    [[SDImageCache sharedImageCache] cleanDisk];
    [[TTLFManager sharedManager].userManager removeDataSave];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            
            if ([fileName isEqualToString:@"t_user.sqlite"]) {
                // 不删除这些。用户信息、离线订单、归档
                
                completion();
                
            }else{
                NSError *error;
                NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
                [fileManager removeItemAtPath:absolutePath error:&error];
                completion();
            }
        }
    }
    
}
- (void)clearCacheCompletion:(void (^)())completion
{
    completion();
}

// 模拟器微信登录
- (void)simulatorLoginSuccess:(SuccessBlock)success Fail:(FailBlock)fail
{
    NSString *getUrl = @"http://app.yangruyi.com/home/Index/wechatRegister?nickName=T2JqY0NoaW5h&unionid=b0tEY3Z3ekh2VTQ2RVhwNjd1S0xVWGJfd21Gdw==&sex=MQ==&headUrl=aHR0cDovL3d4LnFsb2dvLmNuL21tb3Blbi9GTHZocFp3QnhoNzZzMFU5V2M0ZGwzMEFvT1lmeXBRSjduckNvMlpoZ1AxbURuaWF3T0VKVjNRbzJzN25SdzdpYmFPWDJiUUNvYTFDek9GV2F1SHhkYVRrRjVaZEpsRldpY2wvMA==&city=SGFpZGlhbg==&from=Nw==";
    [HTTPManager GET:getUrl params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        KGLog(@"模拟器微信登录返回的信息 = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            UserInfoModel *userModel = [UserInfoModel mj_objectWithKeyValues:result];
            [self saveUserInfo:userModel Success:^{
                success();
            } Fail:^(NSString *errorMsg) {
                fail(errorMsg);
            }];
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}
- (void)saveUserInfo:(UserInfoModel *)userModel Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    
    [[TTLFManager sharedManager].userManager saveUserInfo:userModel Success:^{
        success();
    } Fail:^(NSString *errorMsg) {
        fail(errorMsg);
    }];
}



#pragma mark - 修改信息
// 改昵称
- (void)updateNickName:(NSString *)newNickName Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    
    newNickName = [newNickName stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *url = @"http://app.yangruyi.com/home/Index/updata_userInfo";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:newNickName.base64EncodedString forKey:@"nickName"];
    NSString *geturl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/updata_userInfo?userID=%@&nickName=%@",account.userID.base64EncodedString,newNickName.base64EncodedString];
    NSLog(@"修改昵称的url = %@",geturl);
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            [[TTLFManager sharedManager].userManager updateWithKey:UnickName Value:newNickName];
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}
// 修改手机号码
- (void)updatePhone:(NSString *)phoneNum Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *url = @"http://app.yangruyi.com/home/Index/updata_userInfo";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:phoneNum.base64EncodedString forKey:@"phoneNum"];
    NSString *geturl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/updata_userInfo?userID=%@&phoneNum=%@",account.userID.base64EncodedString,phoneNum.base64EncodedString];
    NSLog(@"修改手机号码的url = %@",geturl);
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            [[TTLFManager sharedManager].userManager updateWithKey:UphoneNum Value:phoneNum];
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

- (void)updateCity:(NSString *)city Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    
    NSString *url = @"http://app.yangruyi.com/home/Index/updata_userInfo";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:city.base64EncodedString forKey:@"city"];
    NSString *geturl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/updata_userInfo?userID=%@&city=%@",account.userID.base64EncodedString,city.base64EncodedString];
    NSLog(@"修改城市的url = %@",geturl);
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            [[TTLFManager sharedManager].userManager updateWithKey:Ucity Value:city];
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

- (void)updateAnimal:(NSString *)animal Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    
    
    NSString *url = @"http://app.yangruyi.com/home/Index/updata_userInfo";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:animal.base64EncodedString forKey:@"animal"];
    NSString *geturl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/updata_userInfo?userID=%@&animal=%@",account.userID.base64EncodedString,animal.base64EncodedString];
    NSLog(@"修改生肖的url = %@",geturl);
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            [[TTLFManager sharedManager].userManager updateWithKey:Uanimal Value:animal];
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

- (void)uploadHeadImge:(UIImage *)image Progress:(void (^)(NSProgress *))progressBlock Success:(SuccessStringBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Index/head_modify";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    
    // 上传头像 模糊度如果是1会出现失败
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    NSString *name = @"file";
    NSString *fileName = @"head.jpeg";
    
    [HTTPManager uploadWithURL:url params:param fileData:data name:name fileName:fileName mimeType:@"jpeg" progress:^(NSProgress *progress) {
        progressBlock(progress);
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSString *result = [[responseObject objectForKey:@"result"] description];
            [[TTLFManager sharedManager].userManager updateWithKey:UheadUrl Value:result];
            success(result);
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}
// 根据用户ID查询用户信息
- (void)searchUserByUserID:(NSString *)sideID Success:(void (^)(UserInfoModel *))success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/index?userID=%@&sideID=%@",account.userID.base64EncodedString,sideID.base64EncodedString];
    NSLog(@"查询用户ID = %@",url);
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"对方的信息 = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            UserInfoModel *userModel = [UserInfoModel mj_objectWithKeyValues:result];
            if ([account.userID isEqualToString:userModel.userID]) {
                // 更新本地数据
                [[TTLFManager sharedManager].userManager removeDataSave];
                [[TTLFManager sharedManager].userManager saveUserInfo:userModel Success:^{
                    success(userModel);
                } Fail:^(NSString *errorMsg) {
                    success(userModel);
                }];
            }else{
                // 对方的
                success(userModel);
            }
            
            
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

#pragma mark - 获取功德值列表
- (void)getPunaNumWithMonth:(NSString *)month Success:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Index/seach_punnanum";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:month.base64EncodedString forKey:@"month"];
    
    NSString *uuurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/seach_punnanum?userID=%@&month=%@",account.userID.base64EncodedString,month.base64EncodedString];
    NSLog(@"功德值增长列表 = %@",uuurl);
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            NSArray *modelArray = [PunaNumListModel mj_objectArrayWithKeyValuesArray:result];
            success(modelArray);
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}


// 花名相关
- (void)sharkActionSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Index/shock";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/shock?userID=%@",account.userID.base64EncodedString];
    NSLog(@"全部花名资源url = %@",allurl);
    
    [HTTPManager GETCache:url parameter:param success:^(id responseObject) {
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if (!error) {
            int code = [[[json objectForKey:@"code"] description] intValue];
            NSString *message = [[json objectForKey:@"message"] description];
            if (code == 1) {
                NSArray *result = [json objectForKey:@"result"];
                NSArray *modelArray = [StageModel mj_objectArrayWithKeyValuesArray:result];
                if (modelArray.count >= 1) {
                    success(modelArray);
                }else{
                    fail(@"没有图标资源");
                }
            }else{
                fail(message);
            }
        }else{
            fail(@"解析失败");
        }
    } failure:^(NSError *error) {
        fail(error.localizedDescription);
    }];
}
- (void)updateStageInfo:(StageModel *)stageModel Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/updata_stage"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:stageModel.stage_id.base64EncodedString forKey:@"stage_id"];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/updata_stage?userID=%@&stage_id=%@",account.userID.base64EncodedString,stageModel.stage_id.base64EncodedString];
    NSLog(@"修改我的花名url = %@",allurl);
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            [[TTLFManager sharedManager].userManager updateWithKey:UstageName Value:stageModel.stage_name];
            [[TTLFManager sharedManager].userManager updateWithKey:UstageIcon Value:stageModel.stage_img];
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}
#pragma mark - 发送动态相关
- (void)getTopicListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    
    NSString *url = @"http://app.yangruyi.com/home/Index/topic";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/topic?userID=%@",account.userID.base64EncodedString];
    NSLog(@"获取话题列表url = %@",allurl);
    
    [HTTPManager GETCache:url parameter:param success:^(id responseObject) {
        
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if (!error) {
            int code = [[[json objectForKey:@"code"] description] intValue];
            NSString *message = [[json objectForKey:@"message"] description];
            if (code == 1) {
                NSArray *result = [json objectForKey:@"result"];
                NSArray *modelArray = [SendTopicModel mj_objectArrayWithKeyValuesArray:result];
                success(modelArray);
            }else{
                fail(message);
            }
        }else{
            fail(@"解析失败");
        }
        
    } failure:^(NSError *error) {
        fail(error.localizedDescription);
    }];
    
}
// 发送有图动态
- (void)sendImgDyn:(UIImage *)image Topic:(SendTopicModel *)topicModel Content:(NSString *)content LocationJson:(NSString *)locationJson IsNoname:(BOOL)isNoName Progress:(void (^)(NSProgress *))progressBlock Success:(SuccessStringBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Index/create_dynamics";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:topicModel.topic_id.base64EncodedString forKey:@"topic_id"];
    [param setValue:content.base64EncodedString forKey:@"contentText"];
    if (locationJson) {
        [param setValue:locationJson.base64EncodedString forKey:@"location"];
    }
    [param setValue:[NSString stringWithFormat:@"%d",isNoName].base64EncodedString forKey:@"nameType"];
    
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *currentTime = [NSString stringWithFormat:@"%@_%.f",account.userID,interval];
    // 上传图片 模糊度如果是1会出现失败
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    NSString *name = @"file";
    NSString *fileName = [NSString stringWithFormat:@"%@.jpeg",currentTime];
    
    [HTTPManager uploadWithURL:url params:param fileData:data name:name fileName:fileName mimeType:@"jpeg" progress:^(NSProgress *progress) {
        progressBlock(progress);
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSString *result = [[responseObject objectForKey:@"result"] description];
            [[TTLFManager sharedManager].userManager updateWithKey:result Value:UpunnaNum];
            success(message);
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}
// 发送无图动态
- (void)sendTextDynWithTopic:(SendTopicModel *)topicModel Content:(NSString *)content LocationJson:(NSString *)locationJson IsNoname:(BOOL)isNoName Success:(SuccessStringBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Index/create_dynamics";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:topicModel.topic_id.base64EncodedString forKey:@"topic_id"];
    [param setValue:content.base64EncodedString forKey:@"contentText"];
    if (locationJson) {
        [param setValue:locationJson.base64EncodedString forKey:@"location"];
    }
    [param setValue:[NSString stringWithFormat:@"%d",isNoName].base64EncodedString forKey:@"nameType"];
    NSString *uuurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/create_dynamics?userID=%@&topic_id=%@&contentText=%@location=%@&isNoName=%@",account.userID.base64EncodedString,topicModel.topic_id.base64EncodedString,content.base64EncodedString,locationJson.base64EncodedString,[NSString stringWithFormat:@"%d",isNoName].base64EncodedString];
    NSLog(@"发送文字动态URL = %@",uuurl);
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSString *result = [[responseObject objectForKey:@"result"] description];
            [[TTLFManager sharedManager].userManager updateWithKey:result Value:UpunnaNum];
            success(message);
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

#pragma mark - 首页佛友圈板块
// 收藏文章
- (void)storeNewsWithModel:(NewsArticleModel *)newsModel Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/News/storeNews";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:newsModel.news_id.base64EncodedString forKey:@"news_id"];
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/News/storeNews?userID=%@&news_id=%@",account.userID.base64EncodedString,newsModel.news_id.base64EncodedString];
    NSLog(@"收藏文章的URL = %@",allurl);
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            success();
        }else{
            fail(message);
        }

    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}
// 收藏列表
- (void)storeListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/News/listStore";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/News/listStore?userID=%@",account.userID.base64EncodedString];
    NSLog(@"收藏列表的URL = %@",allurl);
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            NSArray *modelArray = [NewsArticleModel mj_objectArrayWithKeyValuesArray:result];
            if (modelArray.count > 0) {
                success(modelArray);
            }else{
                fail(@"暂无收藏");
            }
        }else{
            fail(message);
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}
// 删除收藏
- (void)deleteStoreWithModel:(NewsArticleModel *)newsModel Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/News/cancelStore";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:newsModel.storeid.base64EncodedString forKey:@"storeid"];
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/News/cancelStore?userID=%@&storeid=%@",account.userID.base64EncodedString,newsModel.news_id.base64EncodedString];
    NSLog(@"删除收藏的URL = %@",allurl);
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            success();
        }else{
            fail(message);
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}
- (void)commentNewsWithModel:(NewsArticleModel *)newsModel Image:(UIImage *)image CommentText:(NSString *)commentText Success:(void (^)(NewsCommentModel *))success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/News/comment";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:newsModel.news_id.base64EncodedString forKey:@"news_id"];
    
    if (image) {
        // 有图评论
        [param setValue:commentText.base64EncodedString forKey:@"commentText"];
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
        NSString *currentTime = [NSString stringWithFormat:@"%@_%.f",account.userID,interval];
        // 上传图片 模糊度如果是1会出现失败
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        NSString *name = @"file";
        // 图片名称，当前时间戳
        NSString *fileName = [NSString stringWithFormat:@"%@.jpeg",currentTime];
        // 开始上传
        [HTTPManager uploadWithURL:url params:param fileData:data name:name fileName:fileName mimeType:@"jpeg" progress:^(NSProgress *progress) {
            NSLog(@"上传进度 = %g",progress.fractionCompleted);
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"responseObject = %@",responseObject);
            int code = [[[responseObject objectForKey:@"code"] description] intValue];
            NSString *message = [[responseObject objectForKey:@"message"] description];
            if (code == 1) {
                NSDictionary *result = [responseObject objectForKey:@"result"];
                NewsCommentModel *model = [NewsCommentModel mj_objectWithKeyValues:result];
                success(model);
            }else{
                fail(message);
            }
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            fail(error.localizedDescription);
        }];
    }else{
        // 无图评论
        [param setValue:commentText.base64EncodedString forKey:@"commentText"];
        NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/News/comment?userID=%@&news_id=%@&commentText=%@",account.userID.base64EncodedString,newsModel.news_id.base64EncodedString,commentText.base64EncodedString];
        NSLog(@"无图评论 URL = %@",allurl);
        [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"responseObject = %@",responseObject);
            int code = [[[responseObject objectForKey:@"code"] description] intValue];
            NSString *message = [[responseObject objectForKey:@"message"] description];
            if (code == 1) {
                NSDictionary *result = [responseObject objectForKey:@"result"];
                NewsCommentModel *model = [NewsCommentModel mj_objectWithKeyValues:result];
                success(model);
            }else{
                fail(message);
            }
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            fail(error.localizedDescription);
        }];
    }
}
- (void)deleteNewsComment:(NewsCommentModel *)commentModel Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/News/deletecomment";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:commentModel.comment_id.base64EncodedString forKey:@"comment_id"];
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/News/deletecomment?userID=%@&comment_id=%@",account.userID.base64EncodedString,commentModel.comment_id.base64EncodedString];
    NSLog(@"删除评论的url = %@",allurl);
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}
// 获取新闻评论列表
- (void)getNewsCommentWithModel:(NewsArticleModel *)newsModel Success:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/News/listcomment";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:newsModel.news_id.base64EncodedString forKey:@"news_id"];
    
    NSString *uuurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/News/listcomment?userID=%@&news_id=%@",account.userID.base64EncodedString,newsModel.news_id.base64EncodedString];
    NSLog(@"获取新闻的评论列表 = %@",uuurl);
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            if (result.count >= 1) {
                NSArray *modelArray = [NewsCommentModel mj_objectArrayWithKeyValuesArray:result];
                success(modelArray);
            }else{
                fail(@"还没有数据，成为第一个评论者吧");
            }
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}

#pragma mark - 禅修板块——天天礼佛
- (void)getLifoInfoSuccess:(void (^)(TodayLifoInfoModel *))success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Index/showLf";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    
    NSString *uuurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/showLf?userID=%@",account.userID.base64EncodedString];
    NSLog(@"查看今日礼佛信息 = %@",uuurl);
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            TodayLifoInfoModel *lifoModel = [TodayLifoInfoModel mj_objectWithKeyValues:result];
            success(lifoModel);
        }else{
            fail(message);
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

- (void)getLifoResourceSuccess:(void (^)(LifoResourceModel *))success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    
    NSString *url = @"http://app.yangruyi.com/home/Index/qiancheng";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    
    
    [HTTPManager GETCache:url parameter:param success:^(id responseObject) {
//        NSLog(@"礼佛资源 = %@",responseObject);
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if (!error) {
            int code = [[[json objectForKey:@"code"] description] intValue];
            NSString *message = [[json objectForKey:@"message"] description];
            if (code == 1) {
                NSDictionary *result = [json objectForKey:@"result"];
                LifoResourceModel *lifoModel = [LifoResourceModel mj_objectWithKeyValues:result];
                success(lifoModel);
            }else{
                fail(message);
            }
        }else{
            fail(@"解析失败");
        }
    } failure:^(NSError *error) {
        fail(error.localizedDescription);
    }];
    
}

- (void)everydayLifoWithPusa:(FoxiangModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Index/lifo";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:model.f_id.base64EncodedString forKey:@"f_id"];
    NSString *uuurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/lifo?userID=%@&f_id=%@",account.userID.base64EncodedString,model.f_id.base64EncodedString];
    NSLog(@"选择佛像 url = %@",uuurl);
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
            [UD setObject:model.fa_xiang forKey:LastPusaImgURL];
            [UD synchronize];
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}
- (void)everydayLifoWithFlower:(FlowerVaseModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Index/lifo";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:model.flower_id.base64EncodedString forKey:@"flower_id"];
    NSString *uuurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/lifo?userID=%@&flower_id=%@",account.userID.base64EncodedString,model.flower_id.base64EncodedString];
    NSLog(@"选择花瓶 url = %@",uuurl);
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}
- (void)everydayLifoWithXiang:(XiangModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Index/lifo";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:model.x_id.base64EncodedString forKey:@"x_id"];
    NSString *uuurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/lifo?userID=%@&x_id=%@",account.userID.base64EncodedString,model.x_id.base64EncodedString];
    NSLog(@"选择贡香 url = %@",uuurl);
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}
- (void)everydayLifoWithFruit:(FruitBowlModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Index/lifo";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:model.fruit_id.base64EncodedString forKey:@"fruit_id"];
    NSString *uuurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/lifo?userID=%@&fruit_id=%@",account.userID.base64EncodedString,model.fruit_id.base64EncodedString];
    NSLog(@"选择果盘 url = %@",uuurl);
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}
- (void)everydayLifoWithFopai:(FopaiModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Index/lifo";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:model.pai_id.base64EncodedString forKey:@"pai_id"];
    NSString *uuurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/lifo?userID=%@&pai_id=%@",account.userID.base64EncodedString,model.pai_id.base64EncodedString];
    NSLog(@"选择佛牌 url = %@",uuurl);
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

#pragma mark - 禅修板块——素食生活
// 上传素食
- (void)shareVageWithVageName:(NSString *)vageName Story:(NSString *)story Images:(NSArray *)imageArray VageFoods:(NSString *)foods Steps:(NSString *)steps Progress:(void (^)(NSProgress *))progressBlock Success:(void (^)(NSDictionary *))success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Vegetarian/addvegetar";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:vageName.base64EncodedString forKey:@"vege_name"];
    [param setValue:story.base64EncodedString forKey:@"vege_desc"];
    [param setValue:foods.base64EncodedString forKey:@"vege_food"];
    [param setValue:steps.base64EncodedString forKey:@"vege_steps"];
    
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/vegetarian/addvegetar?userID=%@&vegeName=%@&story=%@&vageMaterial=%@&vageSteps=%@",account.userID.base64EncodedString,vageName.base64EncodedString,story.base64EncodedString,foods.base64EncodedString,steps.base64EncodedString];
    NSLog(@"上传素食的URL = %@",allurl);
    
    
    [HTTPManager uploadFilesWithURL:url params:param fileArray:imageArray progress:^(NSProgress *progress) {
        progressBlock(progress);
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            success(result);
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error = %@",error);
        fail(error.localizedDescription);
    }];
    
}

// 获取素食列表
- (void)getVageListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Vegetarian/index";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    NSLog(@"获取素食列表 = http://app.yangruyi.com/home/Vegetarian/index?userID=%@",account.userID.base64EncodedString);
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            NSArray *modelArray = [VegeInfoModel mj_objectArrayWithKeyValuesArray:result];
            success(modelArray);
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}
// 搜索素食
- (void)searchVege:(NSString *)keyWord Success:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Vegetarian/seachVege";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:keyWord.base64EncodedString forKey:@"name"];
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Vegetarian/seachVege?userID=%@&name=%@",account.userID.base64EncodedString,keyWord.base64EncodedString];
    NSLog(@"搜索素食 = %@",allurl);
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            NSArray *modelArray = [VegeInfoModel mj_objectArrayWithKeyValuesArray:result];
            if (modelArray.count > 0) {
                success(modelArray);
            }else{
                fail(@"暂无结果\r请更改关键字");
            }
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}
// 添加素食收藏
- (void)addStoreVegeWithModel:(VegeInfoModel *)vegeModel Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Vegetarian/vegeCollect";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:vegeModel.vege_id.base64EncodedString forKey:@"vege_id"];
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Vegetarian/vegeCollect?userID=%@&vege_id=%@",account.userID.base64EncodedString,vegeModel.vege_id.base64EncodedString];
    NSLog(@"收藏素食 = %@",allurl);
    
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

// 取消素食收藏
- (void)cancleStoreVegeWithModel:(VegeInfoModel *)vegeModel Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Vegetarian/cancelVegeCollect";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:vegeModel.vege_id.base64EncodedString forKey:@"vege_id"];
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Vegetarian/cancelVegeCollect?userID=%@&vege_id=%@",account.userID.base64EncodedString,vegeModel.vege_id.base64EncodedString];
    NSLog(@"取消收藏素食 = %@",allurl);
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}
// 收藏素食列表
- (void)storeVegeListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Vegetarian/vegeCollectList";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Vegetarian/vegeCollectList?userID=%@",account.userID.base64EncodedString];
    NSLog(@"素食收藏列表 = %@",allurl);
    
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            NSArray *modelArray = [VegeInfoModel mj_objectArrayWithKeyValuesArray:result];
            if (modelArray.count > 0) {
                success(modelArray);
            }else{
                fail(@"您还没有添加素食\r快去素食广场发现素食吧");
            }
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}
// 我发布的素食列表
- (void)myCreateVegeListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Vegetarian/myVege";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Vegetarian/myVege?userID=%@",account.userID.base64EncodedString];
    NSLog(@"我发布的素食列表 = %@",allurl);
    
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            NSArray *modelArray = [VegeInfoModel mj_objectArrayWithKeyValuesArray:result];
            if (modelArray.count > 0) {
                success(modelArray);
            }else{
                fail(@"您还没有发布素食\r快去分享您的素食经验吧");
            }
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}
// 删除我发布的素食
- (void)deleteMyVegeWithModel:(VegeInfoModel *)vegeModel Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Vegetarian/deleteVege";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:vegeModel.vege_id.base64EncodedString forKey:@"vege_id"];
    
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Vegetarian/deleteVege?userID=%@&vege_id=%@",account.userID.base64EncodedString,vegeModel.vege_id.base64EncodedString];
    NSLog(@"删除我发布的素食 = %@",allurl);
    
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"删除我发布的素食 = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}


@end
