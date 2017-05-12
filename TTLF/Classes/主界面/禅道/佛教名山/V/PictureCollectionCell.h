//
//  PictureCollectionCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/12.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureCollectionCell : UICollectionViewCell

/** 图片地址 */
@property (copy,nonatomic) NSString *img_url;
/** 初始化 */
+ (instancetype)sharedCell:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath;


@end
