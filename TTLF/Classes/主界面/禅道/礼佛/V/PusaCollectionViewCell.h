//
//  PusaCollectionViewCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/28.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PusaCollectionViewCell : UICollectionViewCell

/** 佛像模型 */
@property (strong,nonatomic) FoxiangModel *model;
/** 回调 */
@property (copy,nonatomic) void (^SelectModelBlock)(FoxiangModel *model);
/** 初始化 */
+ (instancetype)sharedCell:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath;


@end
