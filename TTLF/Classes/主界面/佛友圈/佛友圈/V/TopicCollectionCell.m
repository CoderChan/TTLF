//
//  TopicCollectionCell.m
//  FYQ
//
//  Created by Chan_Sir on 2017/3/6.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "TopicCollectionCell.h"
#import <Masonry.h>


@interface TopicCollectionCell ()

@property (strong,nonatomic) UILabel *contentLabel;

@end
@implementation TopicCollectionCell

+ (instancetype)sharedTopicCollectionCell:(UICollectionView *)collectionView Path:(NSIndexPath *)indexPath
{
    static NSString *ID = @"TopicCollectionCell";
    TopicCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[TopicCollectionCell alloc]init];
    }
    return cell;
}

- (void)setTopicModel:(SendTopicModel *)topicModel
{
    _topicModel = topicModel;
    _contentLabel.text = topicModel.topic_name;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews
{
    self.backgroundColor = MainColor;
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.font = [UIFont boldSystemFontOfSize:24];
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@50);
        make.left.equalTo(self.contentView.mas_left);
    }];
    
}

@end
