//
//  Account.m
//  FYQ
//
//  Created by Chan_Sir on 2017/2/24.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "Account.h"

@implementation Account

+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    Account *account = [[self alloc]init];
    account.unionid = dict[@"unionid"];
    account.userID = dict[@"userID"];
    
    return account;
}
/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.unionid forKey:@"unionid"];
    [aCoder encodeObject:self.userID forKey:@"userID"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.unionid = [aDecoder decodeObjectForKey:@"unionid"];
        self.userID = [aDecoder decodeObjectForKey:@"userID"];
    }
    return self;
}


@end
