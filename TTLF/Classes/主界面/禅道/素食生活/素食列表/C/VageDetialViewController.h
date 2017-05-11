//
//  VageDetialViewController.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/7.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface VageDetialViewController : SuperViewController

@property (assign,nonatomic) BOOL isPresent;

- (instancetype)initWithVegeModel:(VegeInfoModel *)vegeModel;

@end
