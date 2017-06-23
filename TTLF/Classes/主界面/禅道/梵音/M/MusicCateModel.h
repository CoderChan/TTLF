//
//  MusicCateModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/6/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>


/********** 梵音分类模型 **********/

@interface MusicCateModel : NSObject

// 分类ID
@property (copy,nonatomic) NSString *cate_id;
// 分类名称
@property (copy,nonatomic) NSString *cate_name;
// 分类封面
@property (copy,nonatomic) NSString *cate_img;
// 分类描述
@property (copy,nonatomic) NSString *cate_info;
// 后台排序用
@property (copy,nonatomic) NSString *cate_cort;
// 添加时间
@property (copy,nonatomic) NSString *createtime;

@end
