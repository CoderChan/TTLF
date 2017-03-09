//
//  DiscoverCollectionCell.h
//  FYQ
//
//  Created by Chan_Sir on 2016/12/20.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverCollectionCell : UICollectionViewCell

/** 初始化 */
+ (instancetype)sharedCell:(UICollectionView *)collectionView Path:(NSIndexPath *)indexPath;

@end
