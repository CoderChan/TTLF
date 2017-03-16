//
//  TopicCollectionCell.h
//  FYQ
//
//  Created by Chan_Sir on 2017/3/6.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendTopicModel.h"

@interface TopicCollectionCell : UICollectionViewCell

@property (strong,nonatomic) SendTopicModel *topicModel;

+ (instancetype)sharedTopicCollectionCell:(UICollectionView *)collectionView Path:(NSIndexPath *)indexPath;

@end
