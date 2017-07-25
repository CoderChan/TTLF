//
//  AllUserModel.h
//  TTLF
//
//  Created by Chan_Sir on 2017/7/4.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllUserModel : NSObject

@property (copy,nonatomic) NSString *userid;

@property (copy,nonatomic) NSString *phonenum;

@property (copy,nonatomic) NSString *nickname;

@property (copy,nonatomic) NSString *headurl;

@property (assign,nonatomic) int from;

@property (copy,nonatomic) NSString *register_time;

@property (copy,nonatomic) NSString *punnanum;

@end
