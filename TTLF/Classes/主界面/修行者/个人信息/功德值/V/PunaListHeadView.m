//
//  PunaListHeadView.m
//  FYQ
//
//  Created by Chan_Sir on 2017/3/10.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PunaListHeadView.h"


@interface PunaListHeadView ()

/** 月份 */
@property (strong,nonatomic) UILabel *monthLabel;
/** 总的功德值 */
@property (strong,nonatomic) UILabel *sumLabel;

@end

@implementation PunaListHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = BackColor;
        [self setupSubViews];
    }
    return self;
}

- (void)setYearMonth:(NSString *)yearMonth
{
    _yearMonth = yearMonth;
    yearMonth = [yearMonth stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
    yearMonth = [yearMonth stringByAppendingString:@"月"];
    _monthLabel.text = yearMonth;
}
- (void)setSumPunaNum:(NSString *)sumPunaNum
{
    _sumPunaNum = sumPunaNum;
    _sumLabel.text = [NSString stringWithFormat:@"当月累计增长%@功德值",sumPunaNum];
}

- (void)setupSubViews
{
    self.monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 120, 25)];
    self.monthLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.monthLabel];
    
    self.sumLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.monthLabel.frame), 200, 21)];
//    self.sumLabel.text = @"当月累计增长0.00功德值";
    self.sumLabel.font = [UIFont systemFontOfSize:12];
    self.sumLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.sumLabel];
    
    
    UIImageView *canderIcon = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 12, 46, 46)];
    canderIcon.image = [UIImage imageNamed:@"puna_candle"];
    [self addSubview:canderIcon];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.ClickBlock) {
            _ClickBlock();
        }
    }];
    [self addGestureRecognizer:tap];
}

@end
