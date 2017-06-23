//
//  MusicCollectionViewCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/6/18.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicCollectionViewCell : UICollectionViewCell

@property (strong,nonatomic) MusicCateModel *model;

/** 初始化 */
+ (instancetype)sharedCell:(UICollectionView *)collectionView Path:(NSIndexPath *)indexPath;

@end
