//
//  AddAddressViewController.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface AddAddressViewController : SuperViewController

/** 传入地址模型，区分添加还是修改 */
- (instancetype)initWithModel:(AddressModel *)addressModel;
/** 成功后的回调 */
@property (copy,nonatomic) void (^DidFinishedBlock)();

@end
