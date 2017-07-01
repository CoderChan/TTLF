//
//  MusicPlayerManager.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/29.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MusicPlayerManager.h"
#import "MusicCacheManager.h"

@interface MusicPlayerManager ()<FSAudioControllerDelegate>


@property (strong,nonatomic) FSAudioController *fsController;

@end

@implementation MusicPlayerManager

#pragma mark - 初始化
+ (instancetype)sharedManager
{
    static MusicPlayerManager *playerManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        playerManager = [[self alloc]init];
    });
    return playerManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 预设一些信息
        
    }
    return self;
}

#pragma mark - 开始播放
- (void)beginPlayWithModel:(AlbumInfoModel *)model
{
    // 先检测有没有缓存，有缓存就播放
    NSString *cachePath = [self searchFilePathByFileName:model.name];
    if (cachePath) {
        // 已经下载。直接播放本地音乐
        
    }else{
        // 没有下载，播放网络流媒体
        self.fsController = nil;
        self.fsController = [[FSAudioController alloc]initWithUrl:[NSURL URLWithString:model.music_desc]];
        self.fsController.delegate = self;
        [self.fsController play];
        
        // 记录当前播放的音乐ID
        NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
        [UD setObject:model.music_id forKey:LastMusicID];
        [UD synchronize];
        
    }
}
#pragma mark - 继续播放
- (void)continuePlay
{
//    [self.fsController play];
}
#pragma mark - 是否正在播放
- (BOOL)isPlaying
{
    return [self.fsController isPlaying];
}
#pragma mark - 暂停播放
- (void)pause
{
    [self.fsController pause];
}

#pragma mark - 停止播放
- (void)stop
{
    [self.fsController stop];
    // 清除当前播放的音乐ID
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    [UD removeObjectForKey:LastMusicID];
}

#pragma mark - 代理
- (BOOL)audioController:(FSAudioController *)audioController allowPreloadingForStream:(FSAudioStream *)stream
{
    return YES;
}

// 判断文件是否已经在沙盒中已经存在？
- (NSString *)searchFilePathByFileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    if (result) {
        return filePath;
    }else{
        return nil;
    }
}


@end
