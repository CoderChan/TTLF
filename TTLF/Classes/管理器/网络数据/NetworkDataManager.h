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
#import "UserInfoModel.h"
#import "WechatAuthModel.h"
#import "WechatInfoModel.h"
#import "StageModel.h"
#import "SendTopicModel.h"
#import "PunaNumListModel.h"
#import "LifoResourceModel.h"
#import "TodayLifoInfoModel.h"
#import "NewsArticleModel.h"
#import "NewsCommentModel.h"
#import "VegeInfoModel.h"
#import "AreaListModel.h"
#import "PlaceDiscussModel.h"
#import "PlaceDetialModel.h"
#import "AddressModel.h"
#import "GoodsClassModel.h"
#import "GoodsInfoModel.h"
#import "GoodsOrderModel.h"
#import "BookInfoModel.h"
#import "BookCommentModel.h"
#import "MusicCateModel.h"
#import "AlbumInfoModel.h"
#import "MusicCommentModel.h"
#import "WechatPayInfoModel.h"



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
- (void)uploadHeadImage:(UIImage *)image Progress:(void (^)(NSProgress *progress))progressBlock Success:(SuccessStringBlock)success Fail:(FailBlock)fail;
// 上传背景图
- (void)uploadBackImage:(UIImage *)image Progress:(void (^)(NSProgress *progress))progressBlock Success:(SuccessStringBlock)success Fail:(FailBlock)fail;
// 根据用户ID查询用户信息
- (void)searchUserByUserID:(NSString *)sideID Success:(void (^)(UserInfoModel *userModel))success Fail:(FailBlock)fail;
// 推广成功之后增加功德值
- (void)shareNineTableCompletion:(void (^)())completion;


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
- (void)commentNewsWithModel:(NewsArticleModel *)newsModel Image:(UIImage *)image CommentText:(NSString *)commentText Success:(void (^)(NewsCommentModel *model))success Fail:(FailBlock)fail;
// 删除自己的评论
- (void)deleteNewsComment:(NewsCommentModel *)commentModel Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 管理员删除文章评论
- (void)adminDeleteNewsComment:(NewsCommentModel *)commentModel Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 获取文章的评论列表
- (void)getNewsCommentWithModel:(NewsArticleModel *)newsModel Success:(SuccessModelBlock)success Fail:(FailBlock)fail;




// 获取话题列表
- (void)getTopicListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 发送有图动态
- (void)sendImgDyn:(UIImage *)image Topic:(SendTopicModel *)topicModel Content:(NSString *)content LocationJson:(NSString *)locationJson IsNoname:(BOOL)isNoName Progress:(void (^)(NSProgress *progress))progressBlock Success:(SuccessStringBlock)success Fail:(FailBlock)fail;
// 发送无图动态
- (void)sendTextDynWithTopic:(SendTopicModel *)topicModel Content:(NSString *)content LocationJson:(NSString *)locationJson IsNoname:(BOOL)isNoName Success:(SuccessStringBlock)success Fail:(FailBlock)fail;

#pragma mark - 禅修板块——佛典
// 获取佛典信息列表
- (void)getBookListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 下载佛典
- (void)downLoadBookWithModel:(BookInfoModel *)model Progress:(void (^)(NSProgress *progress))progressBlock Success:(SuccessStringBlock)success Fail:(FailBlock)fail;
// 搜索佛典
- (void)searchBookByKeyWord:(NSString *)keyWord Success:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 发布佛典评论
- (void)sendCommentWithModel:(BookInfoModel *)model Content:(NSString *)content Success:(void (^)(BookCommentModel *commentModel))success Fail:(FailBlock)fail;
// 获取佛典下的评论列表
- (void)getBookCommentWithModel:(BookInfoModel *)model Success:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 删除佛典下的某条评论
- (void)deleteBookCommentWithModel:(BookCommentModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail;

#pragma mark - 梵音板块
// 梵音分类列表
- (void)musicCateListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 根据梵音分类获取mp3专辑列表
- (void)albumListByModel:(MusicCateModel *)model Success:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 根据缓存的梵音分类ID获取MP3列表
- (void)getCacheAlbumListByCateID:(NSString *)cateID Success:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 搜索梵音
- (void)searchMusicByKey:(NSString *)keyWord Success:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 下载梵音到本地
- (void)downLoadMusicWithModel:(AlbumInfoModel *)model Progress:(void (^)(NSProgress *progress))progressBlock Success:(SuccessStringBlock)success Fail:(FailBlock)fail;
// 获取梵音下的评论
- (void)musicCommentListWithModel:(AlbumInfoModel *)model Success:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 评论某个梵音
- (void)commentMusicWithModel:(AlbumInfoModel *)model Content:(NSString *)content Success:(void (^)(MusicCommentModel *commentModel))success Fail:(FailBlock)fail;
// 删除梵音下的某条评论
- (void)deleteMusicCommentWithModel:(MusicCommentModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail;


#pragma mark - 禅修板块——天天礼佛
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


#pragma mark - 禅修板块——素食生活
// 上传素食
- (void)shareVageWithVageName:(NSString *)vageName Story:(NSString *)story Images:(NSArray *)imageArray VageFoods:(NSString *)foods Steps:(NSString *)steps Progress:(void (^)(NSProgress *progress))progressBlock Success:(void (^)(NSDictionary *vegeDict))success Fail:(FailBlock)fail;
// 获取素食列表
- (void)getVageListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 搜索素食
- (void)searchVege:(NSString *)keyWord Success:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 添加素食收藏
- (void)addStoreVegeWithModel:(VegeInfoModel *)vegeModel Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 取消收藏
- (void)cancleStoreVegeWithModel:(VegeInfoModel *)vegeModel Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 收藏列表
- (void)storeVegeListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 我发布的素食列表
- (void)myCreateVegeListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 删除我发布的
- (void)deleteMyVegeWithModel:(VegeInfoModel *)vegeModel Success:(SuccessBlock)success Fail:(FailBlock)fail;

#pragma mark - 禅修板块 -- 佛教名山
// 随机获取20个景区作为首页
- (void)randomPlaceListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 获取景点地区列表
- (void)areaListSuccess:(void (^)(AreaListModel *areaListModel))success Fail:(FailBlock)fail;
// 获取某地区的景区列表
- (void)placeListWithModel:(AreaDetialModel *)areaModel Success:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 对某个景点发表评论
- (void)sendDiscussWithModel:(PlaceDetialModel *)placeModel Content:(NSString *)content Images:(NSArray *)imageArray Progress:(void (^)(NSProgress *progress))progressBlock Success:(void (^)(PlaceDiscussModel *model))success Fail:(FailBlock)fail;
// 获取某个景区的评论列表
- (void)placeDiscussWithModel:(PlaceDetialModel *)placeModel Success:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 删除我发布的某个评论
- (void)deletePlaceCommentWithModel:(PlaceDiscussModel *)discussModel Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 管理员删除不良评论
- (void)adminDeletePlaceCommentWithModel:(PlaceDiscussModel *)discussModel Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 获取某个景区的图集
- (void)placePicturesWithModel:(PlaceDetialModel *)placeModel Success:(SuccessModelBlock)success Fail:(FailBlock)fail;

#pragma mark - 商城板块
// 添加地址
- (void)addNewAddressWithModel:(AddressModel *)addressModel Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 地址列表
- (void)getAddressListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 修改\更新地址
- (void)updateAddressWithModel:(AddressModel *)addressModel Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 删除地址
- (void)deleteAddressWithModel:(AddressModel *)addressModel Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 设置默认地址
- (void)setDefaultAddress:(AddressModel *)addressModel Success:(SuccessBlock)success Fail:(FailBlock)fail;

// 获取商品分类列表
- (void)shopClassListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 获取商品分类下的商品列表
- (void)goodsListWithCateModel:(GoodsClassModel *)model Success:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 添加商品到订单列表
- (void)addGoodsToOrderListWithModel:(GoodsInfoModel *)goodsModel Nums:(NSString *)nums Remark:(NSString *)remark PayType:(int)payType PlaceModel:(AddressModel *)addressModel Success:(void (^)(WechatPayInfoModel *wechatPayModel))success Fail:(FailBlock)fail;
// 获取用户订单列表
- (void)orderListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 管理员获取全部订单列表
- (void)getAllOrderListWithDate:(NSString *)date Success:(SuccessModelBlock)success Fail:(FailBlock)fail;


@end
