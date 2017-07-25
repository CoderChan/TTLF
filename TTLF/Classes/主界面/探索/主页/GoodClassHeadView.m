//
//  GoodClassHeadView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "GoodClassHeadView.h"
#import <Masonry.h>

@interface GoodClassHeadView ()

/** 宣传图 */
@property (strong,nonatomic) UIImageView *adImgView;
/** 该系列主推产品昵称 */
@property (strong,nonatomic) UILabel *nameLabel;


@end

@implementation GoodClassHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(GoodsInfoModel *)model
{
    _model = model;
    _nameLabel.text = model.goods_name;
    [_adImgView sd_setImageWithURL:[NSURL URLWithString:model.goods_logo] placeholderImage:[UIImage imageNamed:@"goods_place"]];
}

- (void)setupSubViews
{
    
    // 广告宣传图
    self.adImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goods_place"]];
    [self addSubview:self.adImgView];
    [self.adImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
    // 主标语
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.height - 20 - 24, self.width - 30, 24)];
    self.nameLabel.text = @"精选小叶紫檀";
    self.nameLabel.textAlignment = NSTextAlignmentRight;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:22];
    self.nameLabel.textColor = [UIColor whiteColor];
    [self.adImgView addSubview:self.nameLabel];
    
    
    // 底部白色栏
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectZero];
    bottomView.backgroundColor = BackColor;
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.adImgView.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    
    // 添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.DidClickBlock) {
            _DidClickBlock(self.model);
        }
    }];
    [self addGestureRecognizer:tap];
    
}

@end
