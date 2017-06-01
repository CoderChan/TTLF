//
//  AddressCacheManager.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/31.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AddressCacheManager.h"
#import <FMDB.h>


static FMDatabase *_db;

@implementation AddressCacheManager

+ (void)initialize
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"t_address.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    
    // 建表语句
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_address (id integer PRIMARY KEY AUTOINCREMENT,address_id varchar,name varchar,phone varchar,address_detail varchar,is_default INTEGER);"];
}

+ (instancetype)sharedManager
{
    static AddressCacheManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)saveAddressArrayWithModel:(AddressModel *)addressModel
{
    // 保存前先删除之前的记录,保持信息最新
    if (![_db open]) {
        NSLog(@"数据库未打开");
    }else{
        NSString *sql = [NSString stringWithFormat:@"insert into t_address (address_id,name,phone,address_detail,is_default) values ('%@','%@','%@','%@','%d')",addressModel.address_id,addressModel.name,addressModel.phone,addressModel.address_detail,addressModel.is_default];
        
        [_db executeUpdate:sql];
    }

}

- (NSArray *)getAddressArray
{
    if (![_db open]) {
        return nil;
    }
    
    NSString *sql = @"SELECT * FROM t_address";
    FMResultSet *result = [_db executeQuery:sql];
    
    NSMutableArray *array = [NSMutableArray array];
    
    while (result.next) {
        AddressModel *model = [[AddressModel alloc]init];
        model.address_id = [result stringForColumn:@"address_id"];
        model.name = [result stringForColumn:@"name"];
        model.phone = [result stringForColumn:@"phone"];
        model.address_detail = [result stringForColumn:@"address_detail"];
        model.is_default = [result boolForColumn:@"is_default"];
        [array addObject:model];
    }
    return array;
}

- (void)deleteAddressCache
{
    if (![_db open]) {
        NSLog(@"数据库未打开");
    }else{
        NSString *sql = @"DELETE FROM t_address";
        [_db executeUpdate:sql];
    }
}

- (void)dealloc
{
    [_db close];
}

@end
