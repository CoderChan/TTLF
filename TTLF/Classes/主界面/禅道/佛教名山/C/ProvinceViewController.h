//
//  ProvinceViewController.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/25.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface ProvinceViewController : SuperViewController

@property (copy,nonatomic) void (^SelectProvinceBlock)(NSString *province);

@end
