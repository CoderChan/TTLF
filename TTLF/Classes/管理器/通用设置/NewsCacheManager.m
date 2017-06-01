//
//  NewsCacheManager.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/24.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "NewsCacheManager.h"
#import <MJExtension.h>
#import <FMDB.h>


static FMDatabase *_db;

@implementation NewsCacheManager

+ (void)initialize
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"t_news.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    // news_id,storeid,create_time,news_name,news_logo,site,source,source_link,createtime,keywords
    
    // 建表语句
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_news (id integer PRIMARY KEY AUTOINCREMENT,news_id varchar,storeid varchar,create_time varchar,news_name varchar,news_logo varchar,site varchar,source varchar,source_link varchar,createtime varchar,keywords varchar);"];
}

+ (instancetype)sharedManager
{
    static NewsCacheManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}
- (void)saveNewsArrayWithModel:(NewsArticleModel *)newsModel
{
    // 保存前先删除之前的记录,保持信息最新
    if (![_db open]) {
        NSLog(@"数据库未打开");
    }else{
        //    news_id,storeid,create_time,news_name,news_logo,site,source,source_link,createtime,keywords
        
        NSString *sql = [NSString stringWithFormat:@"insert into t_news (news_id,storeid,create_time,news_name,news_logo,site,source,source_link,createtime,keywords) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",newsModel.news_id,newsModel.storeid,newsModel.create_time,newsModel.news_name,newsModel.news_logo,newsModel.site,newsModel.source,newsModel.source_link,newsModel.createtime,newsModel.keywords];
        
        [_db executeUpdate:sql];
    }

}
- (NSArray *)getNewsCacheArray
{
    if (![_db open]) {
        return nil;
    }
    
    NSString *sql = @"SELECT * FROM t_news";
    FMResultSet *result = [_db executeQuery:sql];
    
    NSMutableArray *array = [NSMutableArray array];
    
    //    news_id,storeid,create_time,news_name,news_logo,site,source,source_link,createtime,keywords
    while (result.next) {
        NewsArticleModel *model = [[NewsArticleModel alloc]init];
        model.news_id = [result stringForColumn:@"news_id"];
        model.storeid = [result stringForColumn:@"storeid"];
        model.create_time = [result stringForColumn:@"create_time"];
        model.news_name = [result stringForColumn:@"news_name"];
        model.news_logo = [result stringForColumn:@"news_logo"];
        model.site = [result stringForColumn:@"site"];
        model.source = [result stringForColumn:@"source"];
        model.source_link = [result stringForColumn:@"source_link"];
        model.createtime = [result stringForColumn:@"createtime"];
        model.keywords = [result stringForColumn:@"keywords"];
        
        [array addObject:model];
    }
    return array;
}
- (void)deleteNewsCache
{
    if (![_db open]) {
        NSLog(@"数据库未打开");
    }else{
        NSString *sql = @"DELETE FROM t_news";
        [_db executeUpdate:sql];
    }
}

- (void)dealloc
{
    [_db close];
}

@end
