//
//  MusicCacheManager.m
//  TTLF
//
//  Created by Chan_Sir on 2017/6/25.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MusicCacheManager.h"
#import <FMDB.h>
#import <MJExtension/MJProperty.h>


static FMDatabase *_db;

@implementation MusicCacheManager

#pragma mark - 初始化
+ (void)initialize
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"t_music.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    // music_id,music_name,music_author,music_logo,music_type,music_info,web_url,music_desc,name,music_size
    
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_music (id integer PRIMARY KEY AUTOINCREMENT,music_id varchar,music_name varchar,music_author varchar,music_logo varchar,music_type varchar,music_info varchar,web_url varchar,music_desc varchar,name varchar,music_size varchar);"];
    
}

+ (instancetype)sharedManager
{
    static MusicCacheManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}
- (void)saveMusicArrayWithModel:(AlbumInfoModel *)musicModel
{
    if (![_db open]) {
        NSLog(@"数据库未打开");
    }else{
        // music_id,music_name,music_author,music_logo,music_type,music_info,web_url,music_desc,name,music_size
        NSString *sql = [NSString stringWithFormat:@"insert into t_music (music_id,music_name,music_author,music_logo,music_type,music_info,web_url,music_desc,name,music_size) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",musicModel.music_id,musicModel.music_name,musicModel.music_author,musicModel.music_logo,musicModel.music_type,musicModel.music_info,musicModel.web_url,musicModel.music_desc,musicModel.name,musicModel.music_size];
        
        [_db executeUpdate:sql];
    }
}
- (NSArray *)getMusicCacheArray
{
    if (![_db open]) {
        return nil;
    }
    NSString *sql = @"SELECT * FROM t_music";
    FMResultSet *result = [_db executeQuery:sql];
    
    NSMutableArray *array = [NSMutableArray array];
    // music_id,music_name,music_author,music_logo,music_type,music_info,web_url,music_desc,name,music_size
    while (result.next) {
        AlbumInfoModel *model = [[AlbumInfoModel alloc]init];
        model.music_id = [result stringForColumn:@"music_id"];
        model.music_name = [result stringForColumn:@"music_name"];
        model.music_author = [result stringForColumn:@"music_author"];
        model.music_logo = [result stringForColumn:@"music_logo"];
        model.music_type = [result stringForColumn:@"music_type"];
        model.music_info = [result stringForColumn:@"music_info"];
        model.web_url = [result stringForColumn:@"web_url"];
        model.music_desc = [result stringForColumn:@"music_desc"];
        model.name = [result stringForColumn:@"name"];
        model.music_size = [result stringForColumn:@"music_size"];
        
        [array addObject:model];
    }
    
    // 数组倒叙
    NSArray *resultArray;
    if (array.count > 1) {
        resultArray = [[array reverseObjectEnumerator] allObjects];
    }else{
        resultArray = array;
    }
    
    return array;
}

- (void)deleteOneMusicByMusicID:(NSString *)musicID
{
    if (![_db open]) {
        NSLog(@"数据库未打开");
    }else{
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_music WHERE music_id = %@",musicID];
        [_db executeUpdate:sql];
    }
}

- (void)deleMusicCache
{
    if (![_db open]) {
        NSLog(@"数据库未打开");
    }else{
        NSString *sql = @"DELETE FROM t_music";
        [_db executeUpdate:sql];
    }
}

- (void)dealloc
{
    [_db close];
}

@end
