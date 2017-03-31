//
//  HomeReusableView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/28.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "HomeReusableView.h"


@interface HomeReusableView ()

@property (strong,nonatomic) UILabel *titleLabel;

@end

@implementation HomeReusableView


- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(89, 81, 101, 1);
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews
{
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 120, 40)];
    self.titleLabel.text = @"佛教圣地";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self addSubview:self.titleLabel];
    
    UIImageView *detialV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cm2_login_arr_gray_night_prs"]];
    [detialV setFrame:CGRectMake(self.width - 30, 5, 32, 30)];
    [self addSubview:detialV];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.DidClickBlock) {
            _DidClickBlock();
        }
    }];
    [self addGestureRecognizer:tap];
    
}

@end
