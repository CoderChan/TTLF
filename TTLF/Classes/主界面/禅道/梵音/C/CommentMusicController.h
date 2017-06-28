//
//  CommentMusicController.h
//  TTLF
//
//  Created by Chan_Sir on 2017/6/24.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface CommentMusicController : SuperViewController

- (instancetype)initWithModel:(AlbumInfoModel *)model WithArray:(NSArray *)array;

@property (copy,nonatomic) void (^CommentNumBlock)(NSArray *commentArray);

@end
