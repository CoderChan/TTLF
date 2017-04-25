//
//  NetworkDataManager.h
//  FYQ
//
//  Created by Chan_Sir on 2017/2/6.
//  Copyright © 2017年 陈振超. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "HTTPManager.h"
#import "WXApi.h"
#import "WechatAuthModel.h"
#import "WechatInfoModel.h"
#import "StageModel.h"
#import "SendTopicModel.h"
#import "PunaNumListModel.h"
#import "LifoResourceModel.h"
#import "TodayLifoInfoModel.h"
#import "NewsArticleModel.h"



typedef void (^SuccessBlock)();
typedef void(^FailBlock)(NSString *errorMsg);

typedef void (^SuccessModelBlock)(NSArray *array);

typedef void (^SuccessStringBlock)(NSString *string);


@interface NetworkDataManager : NSObject

+ (instancetype)sharedManager;

#pragma mark - 用户板块


// 手机号码注册
- (void)registerByPhone:(NSString *)phoneNum Pass:(NSString *)passNum Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 手机号码登录
- (void)loginByPhone:(NSString *)phoneNum Pass:(NSString *)passNum Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 忘记密码操作，设置新密码
- (void)setNewPassWord:(NSString *)phoneNum Pass:(NSString *)newPass Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 退出登录
- (void)returnAccountSuccess:(SuccessBlock)success Fail:(FailBlock)fail;
// 微信注册登录
- (void)wechatLoginResponse:(SendAuthResp *)response Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 模拟器登录
- (void)simulatorLoginSuccess:(SuccessBlock)success Fail:(FailBlock)fail;
// 清除缓存
- (void)clearCacheCompletion:(void(^)())completion;


// 修改昵称
- (void)updateNickName:(NSString *)newNickName Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 修改手机号码
- (void)updatePhone:(NSString *)phoneNum Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 修改生肖
- (void)updateAnimal:(NSString *)animal Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 修改城市
- (void)updateCity:(NSString *)city Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 上传头像
- (void)uploadHeadImge:(UIImage *)image Progress:(void (^)(NSProgress *progress))progressBlock Success:(SuccessStringBlock)success Fail:(FailBlock)fail;


// 获取摇一摇全部信息
- (void)sharkActionSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 更新花名
- (void)updateStageInfo:(StageModel *)stageModel Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 查看功德值记录
- (void)getPunaNumWithMonth:(NSString *)month Success:(SuccessModelBlock)success Fail:(FailBlock)fail;


#pragma mark - 佛友圈板块
// 收藏文章
- (void)storeNewsWithModel:(NewsArticleModel *)newsModel Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 收藏列表
- (void)storeListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 删除收藏
- (void)deleteStoreWithModel:(NewsArticleModel *)newsModel Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 对新闻、文章进行评论
- (void)commentNewsWithModel:(NewsArticleModel *)newsModel Image:(UIImage *)image CommentText:(NSString *)commentText Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 获取文章的评论列表
- (void)getNewsCommentWithModel:(NewsArticleModel *)newsModel Success:(SuccessModelBlock)success Fail:(FailBlock)fail;


// 获取话题列表
- (void)getTopicListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 发送有图动态
- (void)sendImgDyn:(UIImage *)image Topic:(SendTopicModel *)topicModel Content:(NSString *)content LocationJson:(NSString *)locationJson IsNoname:(BOOL)isNoName Progress:(void (^)(NSProgress *progress))progressBlock Success:(SuccessStringBlock)success Fail:(FailBlock)fail;
// 发送无图动态
- (void)sendTextDynWithTopic:(SendTopicModel *)topicModel Content:(NSString *)content LocationJson:(NSString *)locationJson IsNoname:(BOOL)isNoName Success:(SuccessStringBlock)success Fail:(FailBlock)fail;


#pragma mark - 禅修板块
// 查看当天礼佛信息
- (void)getLifoInfoSuccess:(void (^)(TodayLifoInfoModel *lifoModel))success Fail:(FailBlock)fail;
// 获取佛像、香、花瓶、果盘、佛牌资源
- (void)getLifoResourceSuccess:(void (^)(LifoResourceModel *lifoModel))success Fail:(FailBlock)fail;
// 上传礼佛信息到当天
- (void)everydayLifoWithPusa:(FoxiangModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail;
- (void)everydayLifoWithFlower:(FlowerVaseModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail;
- (void)everydayLifoWithXiang:(XiangModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail;
- (void)everydayLifoWithFruit:(FruitBowlModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail;
- (void)everydayLifoWithFopai:(FopaiModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail;




@end
