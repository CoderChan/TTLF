//
//  PictureCollectionCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/12.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PictureCollectionCell.h"

#define SpaceNum 2
@interface PictureCollectionCell ()

@property (strong,nonatomic) UIImageView *pictureView;

@end

@implementation PictureCollectionCell

+ (instancetype)sharedCell:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"PictureCollectionCell";
    PictureCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[PictureCollectionCell alloc]init];
    }
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setImg_url:(NSString *)img_url
{
    _img_url = img_url;
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:img_url] placeholderImage:[UIImage imageWithColor:HWRandomColor]];
}

- (void)setupSubViews
{
    CGFloat width = (SCREEN_WIDTH - 5*SpaceNum) / 4;
    CGFloat height = width + 5;
    self.pictureView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    self.pictureView.contentMode = UIViewContentModeScaleAspectFill;
    [self.pictureView setContentScaleFactor:[UIScreen mainScreen].scale];
    self.pictureView.layer.masksToBounds = YES;
    self.pictureView.autoresizingMask = UIViewAutoresizingFlexibleHeight & UIViewAutoresizingFlexibleWidth;
    self.pictureView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.pictureView];
}

@end
