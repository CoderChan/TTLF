//
//  AlbumInfoModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/6/23.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumInfoModel : NSObject

// 音乐ID
@property (copy,nonatomic) NSString *music_id;
// 音乐名称
@property (copy,nonatomic) NSString *music_name;
// 作者
@property (copy,nonatomic) NSString *music_author;
// 网页播放链接
@property (copy,nonatomic) NSString *music_desc;
// 封面
@property (copy,nonatomic) NSString *music_logo;
// 类型ID
@property (copy,nonatomic) NSString *music_type;
// 简介、歌词
@property (copy,nonatomic) NSString *music_info;
// 文件大小
@property (copy,nonatomic) NSString *music_size;
// 分享页
@property (copy,nonatomic) NSString *web_url;
// 下载文件夹
@property (copy,nonatomic) NSString *name;

// 列表序号 索引
@property (assign,nonatomic) NSInteger index;

@end
