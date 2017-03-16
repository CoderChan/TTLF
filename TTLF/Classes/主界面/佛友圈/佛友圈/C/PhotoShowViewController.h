//
//  PhotoShowViewController.h
//  FYQ
//
//  Created by Chan_Sir on 2017/3/3.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface PhotoShowViewController : SuperViewController

@property (copy,nonatomic) void (^DeleteIMGBlock)();

- (instancetype)initWithImages:(NSArray *)imageArray;

@end
