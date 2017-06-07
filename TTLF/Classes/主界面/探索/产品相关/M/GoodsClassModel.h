//
//  GoodsClassModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/6/2.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsClassModel : NSObject

/** 分类ID */
@property (copy,nonatomic) NSString *cate_id;
/** 分类名称 */
@property (copy,nonatomic) NSString *cate_name;
/** 分类封面 */
@property (copy,nonatomic) NSString *cate_img;
/** path */
@property (copy,nonatomic) NSString *path;
/** 父类ID */
@property (copy,nonatomic) NSString *parent_id;

@end
