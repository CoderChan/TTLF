//
//  PusaCollectionViewCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/28.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PusaCollectionViewCell.h"
#import <Masonry.h>


@interface PusaCollectionViewCell ()

/** 佛像 */
@property (strong,nonatomic) UIImageView *pusaImgView;
/** 佛像名称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 佛像简介 */
@property (strong,nonatomic) UITextView *descTextView;

@end

@implementation PusaCollectionViewCell

+ (instancetype)sharedCell:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"PusaCollectionViewCell";
    PusaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[PusaCollectionViewCell alloc]init];
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
- (void)setModel:(FoxiangModel *)model
{
    _model = model;
    [_pusaImgView sd_setImageWithURL:[NSURL URLWithString:model.fa_xiang] placeholderImage:[UIImage imageNamed:@"lifo_no_pusa"]];
    _nameLabel.text = model.fa_ming;
    _descTextView.text = model.desc;
}
- (void)setupSubViews
{
    // 佛像名称
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.nameLabel.text = @"释迦牟尼佛";
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:22];
    self.nameLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).offset(30);
        make.height.equalTo(@30);
    }];
    
    // 佛像图
    self.pusaImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lifo_no_pusa"]];
    self.pusaImgView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.pusaImgView];
    [self.pusaImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
        make.width.equalTo(@(270*CKproportion));
        make.bottom.equalTo(self.mas_centerY);
    }];
    
    // 恭请按钮
    UIImageView *selectBtnBgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lifo_gongqing_btn"]];
    selectBtnBgView.userInteractionEnabled = YES;
    [self.contentView addSubview:selectBtnBgView];
    [selectBtnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-30);
        make.width.equalTo(@120);
        make.height.equalTo(@45);
    }];
    
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton.backgroundColor = [UIColor clearColor];
    [selectButton setTitle:@"恭请礼佛" forState:UIControlStateNormal];
    selectButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [selectButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (_SelectModelBlock) {
            _SelectModelBlock(self.model);
        }
    }];
    [self.contentView addSubview:selectButton];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectBtnBgView.mas_left);
        make.bottom.equalTo(selectBtnBgView.mas_bottom);
        make.right.equalTo(selectBtnBgView.mas_right);
        make.top.equalTo(selectBtnBgView.mas_top);
    }];
    
    // 简介背景图
    UIImageView *descBgImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lifo_desc_bg"]];
    descBgImgView.userInteractionEnabled = YES;
    [self.contentView addSubview:descBgImgView];
    [descBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.pusaImgView.mas_bottom).offset(30);
        make.left.equalTo(self.mas_left).offset(25*CKproportion);
        make.bottom.equalTo(selectBtnBgView.mas_top).offset(-40);
    }];
    
    // 佛像简介
    self.descTextView = [[UITextView alloc]init];
    self.descTextView.editable = NO;
    self.descTextView.selectable = NO;
    self.descTextView.text = @"药师佛全称为药师琉璃光如来,又有人称谓大医王佛,医王善逝或消灾延寿药师佛。为东方琉璃净土的教主。药师本用以比喻能治众生贪、瞋、痴的医师。在中国佛教一般用以祈求消灾延寿。";
    self.descTextView.textColor = RGBACOLOR(247, 247, 247, 1);
    self.descTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.descTextView.showsVerticalScrollIndicator = NO;
    self.descTextView.showsHorizontalScrollIndicator = NO;
    self.descTextView.backgroundColor = [UIColor clearColor];
    [descBgImgView addSubview:self.descTextView];
    [self.descTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(descBgImgView.mas_left).offset(35);
        make.centerX.equalTo(descBgImgView.mas_centerX);
        make.centerY.equalTo(descBgImgView.mas_centerY);
        make.top.equalTo(descBgImgView.mas_top).offset(20);
    }];
    
}


@end
