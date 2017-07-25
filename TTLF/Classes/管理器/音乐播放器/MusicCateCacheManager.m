//
//  MusicCateCacheManager.m
//  TTLF
//
//  Created by Chan_Sir on 2017/7/12.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MusicCateCacheManager.h"
#import <FMDB.h>
#import <MJExtension/MJExtension.h>


static FMDatabase *_db;

@implementation MusicCateCacheManager

#pragma mark - 初始化
+ (void)initialize
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"t_music_cate.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    // cate_id,cate_name,cate_img,cate_info,cate_cort,createtime
    
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_music_cate (id integer PRIMARY KEY AUTOINCREMENT,cate_id varchar,cate_name varchar,cate_img varchar,cate_info varchar,cate_cort varchar,createtime varchar);"];
}
+ (instancetype)sharedManager
{
    static MusicCateCacheManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

#pragma mark - 保存梵音模型
- (void)saveMusicArrayWithModel:(MusicCateModel *)cateModel
{
    if (![_db open]) {
        NSLog(@"数据库未打开");
    }else{
        // cate_id,cate_name,cate_img,cate_info,cate_cort,createtime
        NSString *sql = [NSString stringWithFormat:@"insert into t_music_cate (cate_id,cate_name,cate_img,cate_info,cate_cort,createtime) values ('%@','%@','%@','%@','%@','%@')",cateModel.cate_id,cateModel.cate_name,cateModel.cate_img,cateModel.cate_info,cateModel.cate_cort,cateModel.createtime];
        
        [_db executeUpdate:sql];
    }
}

#pragma mark - 缓存中的梵音模型
- (NSArray *)getMusicCacheArray
{
    if (![_db open]) {
        return nil;
    }
    NSString *sql = @"SELECT * FROM t_music_cate";
    FMResultSet *result = [_db executeQuery:sql];
    
    NSMutableArray *array = [NSMutableArray array];
    // cate_id,cate_name,cate_img,cate_info,cate_cort,createtime
    while (result.next) {
        MusicCateModel *model = [[MusicCateModel alloc]init];
        model.cate_id = [result stringForColumn:@"cate_id"];
        model.cate_name = [result stringForColumn:@"cate_name"];
        model.cate_img = [result stringForColumn:@"cate_img"];
        model.cate_info = [result stringForColumn:@"cate_info"];
        model.cate_cort = [result stringForColumn:@"cate_cort"];
        model.createtime = [result stringForColumn:@"createtime"];
        
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

#pragma mark - 删除某个梵音分类
- (void)deleteOneMusicByMusicID:(NSString *)cateID
{
    if (![_db open]) {
        NSLog(@"数据库未打开");
    }else{
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_music_cate WHERE cate_id = %@",cateID];
        [_db executeUpdate:sql];
    }

}

#pragma mark - 清理缓存
- (void)deleMusicCateCache
{
    if (![_db open]) {
        NSLog(@"数据库未打开");
    }else{
        NSString *sql = @"DELETE FROM t_music_cate";
        [_db executeUpdate:sql];
    }
}

- (void)dealloc
{
    [_db close];
}


@end
