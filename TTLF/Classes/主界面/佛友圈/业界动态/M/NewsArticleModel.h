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
@property (copy,nonatomic) NSString *news_id;
/** 收藏的ID */
@property (copy,nonatomic) NSString *storeid;
/** 收藏的时间 */
@property (copy,nonatomic) NSString *create_time;
/** 文章标题 */
@property (copy,nonatomic) NSString *news_name;
/** 封面图链接 */
@property (copy,nonatomic) NSString *news_logo;
/** 查看文章内容的url */
@property (copy,nonatomic) NSString *site;
/** 来源:如新浪佛学、凤凰佛学 */
@property (copy,nonatomic) NSString *source;
/** 原文链接：当from为原创时为null */
@property (copy,nonatomic) NSString *source_link;
/** 创建时间 */
@property (copy,nonatomic) NSString *createtime;
/** 关键字 */
@property (copy,nonatomic) NSString *keywords;


@end
