//
//  GoodDetialFootView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/23.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "GoodDetialFootView.h"
#import "UIButton+Category.h"

#define PlaceText @"温馨提示：\r1、收到产品时建议不拆装，放置3-5天以适应当地气候环境。\r2、产品介绍图仅供参考，最终效果以实际到手产品为准。\r3、商品适合男女老少，无不良影响。"

@interface GoodDetialFootView ()

/** 文字说明 */
@property (strong,nonatomic) UILabel *contentLabel;


@end

@implementation GoodDetialFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
    
}

- (void)setModel:(GoodsInfoModel *)model
{
    _model = model;
    CGSize size = [model.goods_desc boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]} context:nil].size;
    CGFloat space = 20;
    CGFloat iconHeight = (self.width - 4*space)/3;
    _contentLabel.text = model.goods_desc;
    _contentLabel.height = size.height + 15 + 10 + iconHeight + 10;
}

- (void)setupSubViews
{
    CGSize size = [PlaceText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]} context:nil].size;
    // 产品的其他说明
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, size.height)];
    self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.text = PlaceText;
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self addSubview:self.contentLabel];
    
    
    CGFloat space = 20;
    CGFloat W = (self.width - 4*space)/3;
    CGFloat H = W;
    NSArray *titleArray = @[@"免费包邮",@"老少皆宜",@"专柜正品"];
    NSArray *iconArray = @[@"goods_baoyou",@"goods_person",@"goods_zheng"];
    // 三个描述
    for (int i = 0; i < titleArray.count; i++) {
        CGRect frame;
        frame.size.width = W;
        frame.size.height = H;
        frame.origin.x = (i%3) * (frame.size.width + space) + space;
        frame.origin.y = CGRectGetMaxY(self.contentLabel.frame) + 10;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.enabled = NO;
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:iconArray[i]] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:MainColor forState:UIControlStateNormal];
        button.frame = frame;
        [button centerImageAndTitle:5];
        [self addSubview:button];
        
    }
    
}

@end
