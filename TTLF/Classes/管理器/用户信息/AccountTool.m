//
//  AccountTool.m
//  FYQ
//
//  Created by Chan_Sir on 2017/2/24.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AccountTool.h"


#define accountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@implementation AccountTool

+ (void)saveAccount:(Account *)account
{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:account toFile:accountPath];
}
#pragma mark - 返回账号信息
+ (Account *)account
{
    //  加载模型
    Account *account = [NSKeyedUnarchiver unarchiveObjectWithFile:accountPath];
    return account;
}



@end
