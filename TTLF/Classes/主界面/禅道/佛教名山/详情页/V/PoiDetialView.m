//
//  PoiDetialView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/24.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PoiDetialView.h"


@interface PoiDetialView ()

/** 位置图片 */
@property (strong,nonatomic) UIImageView *coverImgView;
/** 位置名称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 位置类型 */
@property (strong,nonatomic) UILabel *addressLabel;
/** 距离 */
@property (strong,nonatomic) UILabel *distanceLabel;

@end

@implementation PoiDetialView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        self.layer.shadowOpacity = 0.6;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 3;
        self.layer.shadowOffset = CGSizeMake(3, 3);
        [self setupSubViews];
    }
    return self;
}

- (void)setPoiModel:(AMapPOI *)poiModel
{
    _poiModel = poiModel;
    NSArray *imageArray = poiModel.images;
    AMapImage *mapImage = [imageArray firstObject];
    [_coverImgView sd_setImageWithURL:[NSURL URLWithString:mapImage.url] placeholderImage:[UIImage imageNamed:@"location_place"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    CGSize nameSize = [poiModel.name boundingRectWithSize:CGSizeMake(self.width - 125, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]} context:nil].size;
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(self.coverImgView.frame) + 5, 65 - nameSize.height, self.width - 125, nameSize.height + 10);
    _nameLabel.text = poiModel.name;
    CGSize addressSize = [poiModel.address boundingRectWithSize:CGSizeMake(self.width - 125, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    _addressLabel.frame = CGRectMake(self.nameLabel.x, CGRectGetMaxY(self.nameLabel.frame), self.nameLabel.width, addressSize.height);
    _addressLabel.text = poiModel.address.length > 0 ? poiModel.address : poiModel.type;
    
    _distanceLabel.text = poiModel.city;
}

- (void)setupSubViews
{
    // 封面
    self.coverImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 100, 80)];
    self.coverImgView.userInteractionEnabled = YES;
    [self addSubview:self.coverImgView];
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if ([self.delegate respondsToSelector:@selector(poiViewWithType:Model:)]) {
            [_delegate poiViewWithType:ImageShowType Model:self.poiModel];
        }
    }];
    [self.coverImgView addGestureRecognizer:imageTap];
    
    // 名称
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.coverImgView.frame) + 5, 30, self.width - 125, 44)];
    self.nameLabel.numberOfLines = 2;
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self addSubview:self.nameLabel];
    
    // 地址
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.x, CGRectGetMaxY(self.nameLabel.frame), self.nameLabel.width, 42)];
    self.addressLabel.numberOfLines = 2;
    self.addressLabel.textColor = [UIColor grayColor];
    self.addressLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.addressLabel];
    
    // 线
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    xian.frame = CGRectMake(0, self.height - 51, self.width, 2);
    [self addSubview:xian];
    
    // 底部视图
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 130, self.width, 50)];
    bottomView.userInteractionEnabled = YES;
    [self addSubview:bottomView];
    
    // 电话
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [callButton setImage:[UIImage imageNamed:@"map_call"] forState:UIControlStateNormal];
    [callButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if ([self.delegate respondsToSelector:@selector(poiViewWithType:Model:)]) {
            [_delegate poiViewWithType:CallPhoneType Model:self.poiModel];
        }
    }];
    callButton.titleLabel.font = [UIFont systemFontOfSize:13];
    callButton.frame = CGRectMake(30, 10, 100, 30);
    [callButton setTitleColor:GreenColor forState:UIControlStateNormal];
    [bottomView addSubview:callButton];
    
    // 距离
    self.distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width/2, 10, self.width/2, 30)];
    self.distanceLabel.font = [UIFont systemFontOfSize:16];
    [bottomView addSubview:self.distanceLabel];
    
    
    
}

@end
