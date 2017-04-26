//
//  CommentNewsController.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface CommentNewsController : SuperViewController

/** 数据源 */
@property (strong,nonatomic) NewsArticleModel *newsModel;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *commentArray;

@end
