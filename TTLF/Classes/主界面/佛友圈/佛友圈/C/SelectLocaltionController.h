//
//  SelectLocaltionController.h
//  FYQ
//
//  Created by Chan_Sir on 2017/2/28.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"
#import "LocationModel.h"


@interface SelectLocaltionController : SuperViewController

@property (copy,nonatomic) void (^LocationBlock)(LocationModel *locationModel);

@end
