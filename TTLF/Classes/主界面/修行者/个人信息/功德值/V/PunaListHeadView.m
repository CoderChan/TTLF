//
//  PunaListHeadView.m
//  FYQ
//
//  Created by Chan_Sir on 2017/3/10.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PunaListHeadView.h"
#import <Masonry.h>


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
    LogFuncName
    _sumPunaNum = sumPunaNum;
    NSString *sumStr = [NSString stringWithFormat:@"当月累计增长%@功德值",sumPunaNum];
    NSRange range = [sumStr rangeOfString:sumPunaNum];
    NSMutableAttributedString * graytext = [[NSMutableAttributedString alloc] initWithString:sumStr];
    [graytext beginEditing];
    [graytext addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:MainColor} range:range];
    _sumLabel.attributedText =  graytext;
    
}

- (void)setupSubViews
{
    self.monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 120, 25)];
    self.monthLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.monthLabel];
    
    self.sumLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.monthLabel.frame), 200, 21)];
    self.sumLabel.text = @"kkkkkkkk";
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
    
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    [self addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@1);
    }];
}

@end
