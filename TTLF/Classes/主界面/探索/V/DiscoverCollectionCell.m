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
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 1;
        [self setupSubViews];
    }
    return self;
}


- (void)setupSubViews
{
    
    self.imageV = [[UIImageView alloc]init];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:@"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1075802567,266924029&fm=23&gp=0.jpg"] placeholderImage:[UIImage imageWithColor:HWRandomColor] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    [self.contentView addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-30);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
    }];
    
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = @"浙江观世音菩萨道场";
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textColor = TitleColor;
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@21);
        make.top.equalTo(self.imageV.mas_bottom).offset(6);
    }];
    
    
}


@end
