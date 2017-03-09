//
//  DiscoverCollectionCell.m
//  FYQ
//
//  Created by Chan_Sir on 2016/12/20.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "DiscoverCollectionCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>


@interface DiscoverCollectionCell ()

/** 图片 */
@property (strong,nonatomic) UIImageView *imageV;
/** 名称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 商品 */
@property (strong,nonatomic) UILabel *topicLabel;


@end


@implementation DiscoverCollectionCell


+ (instancetype)sharedCell:(UICollectionView *)collectionView Path:(NSIndexPath *)indexPath
{
    static NSString *ID = @"DiscoverCollectionCell";
    DiscoverCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[DiscoverCollectionCell alloc]init];
    }
    return cell;
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
    
    self.imageV = [[UIImageView alloc]init];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:@"https://gd3.alicdn.com/bao/uploaded/i3/TB1LkoOJpXXXXXVXFXXSutbFXXX.jpg_400x400.jpg"] placeholderImage:[UIImage imageWithColor:HWRandomColor] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
//            self.imageV.image = [UIImage boxblurImage:image withBlurNumber:0.2];
        }
    }];
    [self.contentView addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-42);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
    }];
    
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = @"108📿念珠";
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textColor = TitleColor;
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@21);
        make.top.equalTo(self.imageV.mas_bottom);
    }];
    
    self.topicLabel = [[UILabel alloc]init];
    self.topicLabel.text = @"#佛珠#";
    self.topicLabel.textColor = TitleColor;
    self.topicLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.topicLabel];
    [self.topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.height.equalTo(@21);
    }];
    
}


@end
