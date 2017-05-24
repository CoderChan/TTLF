//
//  GoodDetialFootView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/23.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "GoodDetialFootView.h"

@interface GoodDetialFootView ()

/** 文字说明 */
@property (strong,nonatomic) UILabel *contentLabel;
/**  */

@end

@implementation GoodDetialFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BackColor;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    
    // 免邮、正品提示
    
    
    // 产品说明
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH - 30, 135)];
    self.contentLabel.text = @"产品说明：是男是女是，啊没客气客气今晚就。素食描述看看，爱马克思对本年度的绝佳是。斯诺克是肯定的你电脑的，南京济南市加上手机端你觉得呢看什么看什么肯定看懂你得。大男大女多多多多女军多女多军多女多女是安静暗杀教室你手机你叔叔！";
    self.contentLabel.textColor = [UIColor grayColor];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.contentLabel];
}

@end
