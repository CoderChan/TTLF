//
//  AddressModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/26.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

/** 收货地址ID */
@property (copy,nonatomic) NSString *address_id;
/** 收货人姓名 */
@property (copy,nonatomic) NSString *name;
/** 收货人电话 */
@property (copy,nonatomic) NSString *phone;
/** 详细地址 */
@property (copy,nonatomic) NSString *address_detail;
/** 是否为默认地址 */
@property (assign,nonatomic) BOOL is_default;

/** 索引，本地需要 */
@property (assign,nonatomic) NSInteger *index;

@end
