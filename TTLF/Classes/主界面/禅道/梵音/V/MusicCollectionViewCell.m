//
//  MusicCollectionViewCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/6/18.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MusicCollectionViewCell.h"


#define Space 5
@interface MusicCollectionViewCell ()

// 封面
@property (strong,nonatomic) UIImageView *coverImgView;
// 名称
@property (strong,nonatomic) UILabel *nameLabel;
// 作者
@property (strong,nonatomic) UILabel *writerLabel;

@end

@implementation MusicCollectionViewCell

+ (instancetype)sharedCell:(UICollectionView *)collectionView Path:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MusicCollectionViewCell";
    MusicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[MusicCollectionViewCell alloc]init];
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

- (void)setModel:(MusicCateModel *)model
{
    _model = model;
    [_coverImgView sd_setImageWithURL:[NSURL URLWithString:model.cate_img] placeholderImage:[UIImage imageNamed:@"error_place"]];
    _nameLabel.text = model.cate_name;
    _writerLabel.text = model.cate_info;
}

- (void)setupSubViews
{
    CGFloat width = (SCREEN_WIDTH - 3*Space)/2;
    
    // 模板缩略图
    self.coverImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
    self.coverImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.coverImgView setContentScaleFactor:[UIScreen mainScreen].scale];
    self.coverImgView.layer.masksToBounds = YES;
    self.coverImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight & UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:self.coverImgView];
    
    // 模板昵称
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, width, width - 5, 24)];
    self.nameLabel.text = @"梵音名称梵音名称梵音";
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel.textColor = RGBACOLOR(65, 65, 65, 1);
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.nameLabel];
    
    // 作者
    self.writerLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.x, CGRectGetMaxY(self.nameLabel.frame), self.nameLabel.width, 21)];
    self.writerLabel.text = @"作者作者作者";
    self.writerLabel.textColor = [UIColor grayColor];
    self.writerLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.writerLabel];
}


@end
