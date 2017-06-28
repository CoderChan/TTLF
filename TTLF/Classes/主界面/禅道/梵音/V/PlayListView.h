//
//  PlayListView.h
//  TTLF
//
//  Created by Chan_Sir on 2017/6/25.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface PlayListView : UIView

/**
 初始化

 @param playList 播放列表
 @return PlayListView对象
 */
- (instancetype)initWithArray:(NSArray *)playList CurrentIndex:(NSInteger)currentIndex;

/**
 选中的mp3
 */
@property (copy,nonatomic) void (^SelectModelBlock)(AlbumInfoModel *model,NSInteger selectIndex);

@end
