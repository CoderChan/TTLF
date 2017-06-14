//
//  BookCacheManager.m
//  TTLF
//
//  Created by Chan_Sir on 2017/6/14.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "BookCacheManager.h"
#import <FMDB.h>
#import <MJExtension/MJExtension.h>

static FMDatabase *_db;

@implementation BookCacheManager

#pragma mark - 初始化
+ (void)initialize
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"t_book.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    // book_id,book_name,book_author,book_logo,book_type,book_info,cachePath
    
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_book (id integer PRIMARY KEY AUTOINCREMENT,book_id varchar,book_name varchar,book_author varchar,book_logo varchar,book_type varchar,book_info varchar,cachePath varchar);"];
    
}

+ (instancetype)sharedManager
{
    static BookCacheManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

#pragma mark - 保存书籍信息
- (void)saveBookArrayWithModel:(BookInfoModel *)bookModel
{
    if (![_db open]) {
        NSLog(@"数据库未打开");
    }else{
        //book_id,book_name,book_author,book_logo,book_type,book_info,cachePath
        NSString *sql = [NSString stringWithFormat:@"insert into t_book (book_id,book_name,book_author,book_logo,book_type,book_info,cachePath) values ('%@','%@','%@','%@','%@','%@','%@')",bookModel.book_id,bookModel.book_name,bookModel.book_author,bookModel.book_logo,bookModel.book_type,bookModel.book_info,bookModel.cachePath];
        
        [_db executeUpdate:sql];
    }
}

#pragma mark - 获取全部缓存信息
- (NSArray *)getBookCacheArray
{
    if (![_db open]) {
        return nil;
    }
    NSString *sql = @"SELECT * FROM t_book";
    FMResultSet *result = [_db executeQuery:sql];
    
    NSMutableArray *array = [NSMutableArray array];
    
    // book_id,book_name,book_author,book_logo,book_type,book_info,cachePath
    while (result.next) {
        BookInfoModel *model = [[BookInfoModel alloc]init];
        model.book_id = [result stringForColumn:@"book_id"];
        model.book_name = [result stringForColumn:@"book_name"];
        model.book_author = [result stringForColumn:@"book_author"];
        model.book_logo = [result stringForColumn:@"book_logo"];
        model.book_type = [result stringForColumn:@"book_type"];
        model.book_info = [result stringForColumn:@"book_info"];
        model.cachePath = [result stringForColumn:@"cachePath"];
        
        [array addObject:model];
    }
    return array;
}

#pragma mark - 清空全部缓存数据
- (void)deleBookCache
{
    if (![_db open]) {
        NSLog(@"数据库未打开");
    }else{
        NSString *sql = @"DELETE FROM t_book";
        [_db executeUpdate:sql];
    }
}

- (void)dealloc
{
    [_db close];
}


@end
