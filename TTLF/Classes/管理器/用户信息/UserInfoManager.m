//
//  UserInfoManager.m
//  FYQ
//
//  Created by Chan_Sir on 2017/1/27.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "UserInfoManager.h"
#import "AccountTool.h"



@implementation UserInfoManager

#pragma mark - 单例初始化
+ (instancetype)sharedManager
{
    static UserInfoManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}
#pragma mark - 保存数据
- (void)saveUserInfo:(UserInfoModel *)userModel Success:(void (^)())success Fail:(FailBlock)fail
{
    [self removeDataSave];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:userModel.userID forKey:@"userID"];
    if (!userModel.unionid) {
        userModel.unionid = @"phoneRegister";
    }
    [dict setValue:userModel.unionid forKey:@"unionid"];
    Account *account = [Account accountWithDict:dict];
    [AccountTool saveAccount:account];
    
    
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    [UD setObject:userModel.userID forKey:UuserID];
    [UD setObject:userModel.unionid forKey:Uunionid];
    [UD setObject:userModel.isOutHome forKey:UisOutHome];
    [UD setObject:userModel.phoneNum forKey:UphoneNum];
    [UD setObject:userModel.nickName forKey:UnickName];
    [UD setObject:userModel.animal forKey:Uanimal];
    [UD setObject:userModel.city forKey:Ucity];
    [UD setObject:userModel.sex forKey:Usex];
    [UD setObject:userModel.punnaNum forKey:UpunnaNum];
    [UD setObject:userModel.headUrl forKey:UheadUrl];
    [UD setObject:userModel.register_time forKey:UregisterTime];
    [UD setObject:userModel.stageName forKey:UstageName];
    [UD setObject:userModel.stageIcon forKey:UstageIcon];
    [UD setObject:userModel.from forKey:Ufrom];
    [UD setObject:userModel.userBgImg forKey:UuserBgImg];
    
    [UD synchronize];
    
    UserInfoModel *checkModel = [self getUserInfo];
    if (checkModel.userID) {
        success();
    }else{
        fail(@"信息缓存失败，请重新登录");
    }
    
}
#pragma mark - 更新缓存
- (void)updateWithKey:(NSString *)key Value:(NSString *)value
{
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    [UD setObject:value forKey:key];
    [UD synchronize];
}

#pragma mark - 清除缓存
- (void)removeDataSave
{
    
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    // 用户信息
    [UD removeObjectForKey:UuserID];
    [UD removeObjectForKey:Uunionid];
    [UD removeObjectForKey:UisOutHome];
    [UD removeObjectForKey:UphoneNum];
    [UD removeObjectForKey:UnickName];
    [UD removeObjectForKey:Uanimal];
    [UD removeObjectForKey:Ucity];
    [UD removeObjectForKey:Usex];
    [UD removeObjectForKey:UpunnaNum];
    [UD removeObjectForKey:UheadUrl];
    [UD removeObjectForKey:UregisterTime];
    [UD removeObjectForKey:UstageName];
    [UD removeObjectForKey:UstageIcon];
    [UD removeObjectForKey:Ufrom];
    [UD removeObjectForKey:UuserBgImg];
    
    // 其他缓存
    [UD removeObjectForKey:LastPusaImgURL];
    
}

#pragma mark - 获取用户模型
- (UserInfoModel *)getUserInfo
{
    UserInfoModel *userModel = [[UserInfoModel alloc]init];
    
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    NSString *userID = [UD objectForKey:UuserID];
    NSString *unionid = [UD objectForKey:Uunionid];
    NSString *isOutHome = [UD objectForKey:UisOutHome];
    NSString *phoneNum = [UD objectForKey:UphoneNum];
    NSString *nickName = [UD objectForKey:UnickName];
    NSString *animal = [UD objectForKey:Uanimal];
    NSString *city = [UD objectForKey:Ucity];
    NSString *sex = [UD objectForKey:Usex];
    NSString *punnaNum = [UD objectForKey:UpunnaNum];
    NSString *headUrl = [UD objectForKey:UheadUrl];
    NSString *userBgImg = [UD objectForKey:UuserBgImg];
    NSString *register_time = [UD objectForKey:UregisterTime];
    NSString *stageName = [UD objectForKey:UstageName];
    NSString *stageIcon = [UD objectForKey:UstageIcon];
    NSString *from = [UD objectForKey:Ufrom];
    
    userModel.userID = userID;
    userModel.unionid = unionid;
    userModel.isOutHome = isOutHome;
    userModel.phoneNum = phoneNum;
    userModel.nickName = nickName;
    userModel.animal = animal;
    userModel.city = city;
    userModel.punnaNum = punnaNum;
    userModel.headUrl = headUrl;
    userModel.userBgImg = userBgImg;
    userModel.register_time = register_time;
    userModel.stageName = stageName;
    userModel.stageIcon = stageIcon;
    userModel.from = from;
    userModel.sex = sex;
    
    return userModel;
}


@end
