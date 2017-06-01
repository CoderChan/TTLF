//
//  PlaceCacheManager.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/24.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PlaceCacheManager.h"
#import <FMDB.h>
#import <MJExtension.h>


static FMDatabase *_db;

@implementation PlaceCacheManager

+ (void)initialize
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"t_place.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    // scenic_id、scenic_name、areas、scenic_img、strategy、open_time、web_url、scenic_phone、scenic_address、traic、scenic_ticket
    
    // 建表语句
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_place (id integer PRIMARY KEY AUTOINCREMENT,scenic_id varchar,scenic_name varchar,areas varchar,scenic_img varchar,strategy text,open_time varchar,web_url varchar,scenic_phone varchar,scenic_address varchar,traic varchar,scenic_ticket varchar);"];
}

+ (instancetype)sharedManager
{
    static PlaceCacheManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)savePlaceArrayWithModel:(PlaceDetialModel *)placeModel
{
    // 保存前先删除之前的记录,保持信息最新
    if (![_db open]) {
        NSLog(@"数据库未打开");
    }else{
        //    scenic_id、scenic_name、areas、scenic_img、strategy、open_time、web_url、scenic_phone、scenic_address、traic、scenic_ticket
        
        NSString *sql = [NSString stringWithFormat:@"insert into t_place (scenic_id,scenic_name,areas,scenic_img,strategy,open_time,web_url,scenic_phone,scenic_address,traic,scenic_ticket) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",placeModel.scenic_id,placeModel.scenic_name,placeModel.areas,placeModel.scenic_img,placeModel.strategy,placeModel.open_time,placeModel.web_url,placeModel.scenic_phone,placeModel.scenic_address,placeModel.traic,placeModel.scenic_ticket];
        
        [_db executeUpdate:sql];
    }
}

- (NSArray *)getPlaceCacheArray
{
    if (![_db open]) {
        return nil;
    }
    
    NSString *sql = @"SELECT * FROM t_place";
    FMResultSet *result = [_db executeQuery:sql];
    
    NSMutableArray *array = [NSMutableArray array];
    
    //    scenic_id、scenic_name、areas、scenic_img、strategy、open_time、web_url、scenic_phone、scenic_address、traic、scenic_ticket
    while (result.next) {
        PlaceDetialModel *model = [[PlaceDetialModel alloc]init];
        model.scenic_id = [result stringForColumn:@"scenic_id"];
        model.scenic_name = [result stringForColumn:@"scenic_name"];
        model.areas = [result stringForColumn:@"areas"];
        model.scenic_img = [result stringForColumn:@"scenic_img"];
        model.strategy = [result stringForColumn:@"strategy"];
        model.open_time = [result stringForColumn:@"open_time"];
        model.web_url = [result stringForColumn:@"web_url"];
        model.scenic_phone = [result stringForColumn:@"scenic_phone"];
        model.scenic_address = [result stringForColumn:@"scenic_address"];
        model.traic = [result stringForColumn:@"traic"];
        model.scenic_ticket = [result stringForColumn:@"scenic_ticket"];
        [array addObject:model];
    }
    return array;
}

- (void)delePlaceCache
{
    if (![_db open]) {
        NSLog(@"数据库未打开");
    }else{
        NSString *sql = @"DELETE FROM t_place";
        [_db executeUpdate:sql];
    }
}

- (void)dealloc
{
    [_db close];
}

@end
