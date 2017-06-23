//
//  AlbumHeadView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/6/19.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AlbumHeadView.h"
#import <Masonry.h>


@interface AlbumHeadView ()

// 专辑封面
@property (strong,nonatomic) UIImageView *coverImageView;
// 专辑名称
@property (strong,nonatomic) UILabel *nameLabel;
// 作者
@property (strong,nonatomic) UILabel *writerLabel;

@end

@implementation AlbumHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(63, 65, 70, 1);
        self.userInteractionEnabled = YES;
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(MusicCateModel *)model
{
    _model = model;
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:model.cate_img] placeholderImage:[UIImage imageWithColor:MainColor]];
    _nameLabel.text = model.cate_name;
}

- (void)setupSubViews
{
    self.coverImageView = [[UIImageView alloc]init];
    self.coverImageView.backgroundColor = [UIColor clearColor];
    self.coverImageView.layer.masksToBounds = YES;
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.coverImageView setContentScaleFactor:[UIScreen mainScreen].scale];
    self.coverImageView.layer.masksToBounds = YES;
    self.coverImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.coverImageView.layer.cornerRadius = 35;
    [self addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(-15);
        make.centerX.equalTo(self.mas_centerX);
        make.width.and.height.equalTo(@(70));
    }];
    
    // 专辑名称
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = @"海涛法师讲座";
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
    self.nameLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_bottom).offset(5);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@21);
    }];
    
    // 作者
    self.writerLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.writerLabel.text = @"专辑作者";
    self.writerLabel.textAlignment = NSTextAlignmentCenter;
    self.writerLabel.font = [UIFont systemFontOfSize:16];
    self.writerLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.writerLabel];
    [self.writerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.height.equalTo(@21);
    }];
    
}

@end
