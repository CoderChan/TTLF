//
//  FopaiCollectionViewCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/28.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "FopaiCollectionViewCell.h"

@interface FopaiCollectionViewCell ()

/** 佛像 */
@property (strong,nonatomic) UIImageView *fopaiImgView;

@end

@implementation FopaiCollectionViewCell

+ (instancetype)sharedCell:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"FopaiCollectionViewCell";
    FopaiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[FopaiCollectionViewCell alloc]init];
    }
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(FopaiModel *)model
{
    _model = model;
    [_fopaiImgView sd_setImageWithURL:[NSURL URLWithString:model.fopai_img] placeholderImage:[UIImage imageNamed:@"chanxiu"]];
}

- (void)setupSubViews
{
    
    self.fopaiImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chanxiu"]];
    self.fopaiImgView.frame = self.contentView.bounds;
    [self.contentView addSubview:self.fopaiImgView];
    
}

@end
