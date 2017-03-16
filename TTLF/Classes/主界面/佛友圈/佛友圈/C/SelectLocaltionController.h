//
//  SelectLocaltionController.h
//  FYQ
//
//  Created by Chan_Sir on 2017/2/28.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface SelectLocaltionController : SuperViewController

@property (copy,nonatomic) void (^SelectPOIBlock)(AMapPOI *poiModel);

@end
