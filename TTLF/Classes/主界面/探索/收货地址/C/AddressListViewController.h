//
//  AddressListViewController.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface AddressListViewController : SuperViewController

@property (copy,nonatomic) void (^SelectAddressBlock)(AddressModel *model);

@end
