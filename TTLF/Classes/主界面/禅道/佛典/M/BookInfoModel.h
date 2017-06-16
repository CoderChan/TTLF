//
//  BookInfoModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/6/14.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookInfoModel : NSObject

// 佛典ID
@property (copy,nonatomic) NSString *book_id;
// 佛典名称
@property (copy,nonatomic) NSString *book_name;
// 佛典作者
@property (copy,nonatomic) NSString *book_author;
// 佛典封面
@property (copy,nonatomic) NSString *book_logo;
// 佛典类型
@property (copy,nonatomic) NSString *book_type;
// 佛典描述
@property (copy,nonatomic) NSString *book_info;
// 分享链接
@property (copy,nonatomic) NSString *web_url;

// 缓存路径
@property (copy,nonatomic) NSString *cachePath;
// 下载下来的文件名
@property (copy,nonatomic) NSString *name;

// 一个PDF网页
@property (copy,nonatomic) NSString *book_desc;

@end
