//
//  HorizontalCollectionCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoxiangModel.h"


@interface HorizontalCollectionCell : UICollectionViewCell

@property (strong,nonatomic) FoxiangModel *model;

+ (instancetype)sharedCell:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath;


@end
