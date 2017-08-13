//
//  MusicAlumListManager.m
//  TTLF
//
//  Created by Chan_Sir on 2017/8/13.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MusicAlumListManager.h"
#import <FMDB.h>
#import <MJExtension/MJExtension.h>


static FMDatabase *_db;

@implementation MusicAlumListManager

#pragma mark - 初始化
+ (void)initialize
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"t_music_album.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    // music_id,music_name,music_author,music_desc,music_logo,music_type,music_info,music_size,web_url,name,index
    
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_music_album (id integer PRIMARY KEY AUTOINCREMENT,music_id varchar,music_name varchar,music_author varchar,music_desc varchar,music_logo varchar,music_type varchar,music_info varchar,music_size varchar,web_url varchar,name varchar);"];
}

+ (instancetype)sharedManager
{
    static MusicAlumListManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

#pragma mark - 保存梵音模型
- (void)saveMusicArrayWithModel:(AlbumInfoModel *)albumModel
{
    if (![_db open]) {
        NSLog(@"数据库未打开");
    }else{
        // music_id,music_name,music_author,music_desc,music_logo,music_type,music_info,music_size,web_url,name,index
        NSString *sql = [NSString stringWithFormat:@"insert into t_music_album (music_id,music_name,music_author,music_desc,music_logo,music_type,music_info,music_size,web_url,name) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",albumModel.music_id,albumModel.music_name,albumModel.music_author,albumModel.music_desc,albumModel.music_logo,albumModel.music_type,albumModel.music_info,albumModel.music_size,albumModel.web_url,albumModel.name];
        [_db executeUpdate:sql];
    }
    
}

#pragma mark - 获取缓存中的梵音列表
- (NSArray *)getLastMusicListCacheArray
{
    if (![_db open]) {
        return nil;
    }
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    NSString *lastCateID = [UD objectForKey:LastMusicCateID];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_music_album WHERE music_type = %@",lastCateID];
    FMResultSet *result = [_db executeQuery:sql];
    
    NSMutableArray *array = [NSMutableArray array];
    // music_id,music_name,music_author,music_desc,music_logo,music_type,music_info,music_size,web_url,name,index
    while (result.next) {
        AlbumInfoModel *model = [[AlbumInfoModel alloc]init];
        model.music_id = [result stringForColumn:@"music_id"];
        model.music_name = [result stringForColumn:@"music_name"];
        model.music_author = [result stringForColumn:@"music_author"];
        model.music_desc = [result stringForColumn:@"music_desc"];
        model.music_logo = [result stringForColumn:@"music_logo"];
        model.music_type = [result stringForColumn:@"music_type"];
        model.music_info = [result stringForColumn:@"music_info"];
        model.music_size = [result stringForColumn:@"music_size"];
        model.web_url = [result stringForColumn:@"web_url"];
        model.name = [result stringForColumn:@"name"];
        NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
        NSString *lastIndex = [UD objectForKey:LastMusicIndex];
        model.index = [lastIndex integerValue];
        
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

#pragma mark - 某个分类下的专辑列表
- (NSArray *)getAlbumListByCateID:(MusicCateModel *)cateModel
{
    if (![_db open]) {
        return nil;
    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_music_album WHERE music_type = %@",cateModel.cate_id];
    FMResultSet *result = [_db executeQuery:sql];
    
    NSMutableArray *array = [NSMutableArray array];
    // music_id,music_name,music_author,music_desc,music_logo,music_type,music_info,music_size,web_url,name,index
    while (result.next) {
        AlbumInfoModel *model = [[AlbumInfoModel alloc]init];
        model.music_id = [result stringForColumn:@"music_id"];
        model.music_name = [result stringForColumn:@"music_name"];
        model.music_author = [result stringForColumn:@"music_author"];
        model.music_desc = [result stringForColumn:@"music_desc"];
        model.music_logo = [result stringForColumn:@"music_logo"];
        model.music_type = [result stringForColumn:@"music_type"];
        model.music_info = [result stringForColumn:@"music_info"];
        model.music_size = [result stringForColumn:@"music_size"];
        model.web_url = [result stringForColumn:@"web_url"];
        model.name = [result stringForColumn:@"name"];
        NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
        NSString *lastIndex = [UD objectForKey:LastMusicIndex];
        model.index = [lastIndex integerValue];
        
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


#pragma mark - 清理缓存
- (void)deleMusicCateCache
{
    if (![_db open]) {
        NSLog(@"数据库未打开");
    }else{
        NSString *sql = @"DELETE FROM t_music_album";
        [_db executeUpdate:sql];
    }
}
- (void)dealloc
{
    [_db close];
}

@end
