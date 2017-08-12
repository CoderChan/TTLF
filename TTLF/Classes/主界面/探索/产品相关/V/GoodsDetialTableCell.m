//
//  GoodsDetialTableCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/7/29.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "GoodsDetialTableCell.h"

@interface GoodsDetialTableCell ()

@property (strong,nonatomic) UILabel *contentLabel;

@end

@implementation GoodsDetialTableCell

+ (instancetype)sharedCell:(UITableView *)tableView
{
    static NSString *ID = @"GoodsDetialTableCell";
    GoodsDetialTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[GoodsDetialTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(GoodsInfoModel *)model
{
    _model = model;
    _contentLabel.text = model.goods_desc;
}

- (void)setupSubViews
{
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 140)];
    self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self addSubview:self.contentLabel];
}

@end
