//
//  NewsArticleModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/10.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsArticleModel : NSObject

/** 新闻文章的ID */
@property (copy,nonatomic) NSString *newsID;
/** 文章标题 */
@property (copy,nonatomic) NSString *title;
/** 封面图链接 */
@property (copy,nonatomic) NSString *coverUrl;
/** 查看文章内容的url */
@property (copy,nonatomic) NSString *webUrl;
/** 来源:如新浪佛学、凤凰佛学 */
@property (copy,nonatomic) NSString *from;
/** 原文链接：当from为原创时为null */
@property (copy,nonatomic) NSString *fromUrl;
/** 评论 */
@property (copy,nonatomic) NSArray *discussArray;

/** 是否为最新 */
@property (assign,nonatomic) BOOL isNewest;

@end
