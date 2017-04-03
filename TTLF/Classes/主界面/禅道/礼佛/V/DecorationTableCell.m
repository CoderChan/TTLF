//
//  DecorationTableCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/23.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "DecorationTableCell.h"
#import <Masonry.h>

@interface DecorationTableCell ()

@property (strong,nonatomic) UIImageView *iconView;

@property (strong,nonatomic) UILabel *nameLabel;

@end

@implementation DecorationTableCell

+ (instancetype)sharedDecorationCell:(UITableView *)tableView
{
    static NSString *ID = @"DecorationTableCell";
    DecorationTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[DecorationTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupSubViews];
    }
    return self;
}
- (void)setFlowerModel:(FlowerVaseModel *)flowerModel
{
    _flowerModel = flowerModel;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:flowerModel.flower_img] placeholderImage:[UIImage imageNamed:@"lifo_flower_place"]];
    _nameLabel.text = flowerModel.flower_name;
}
- (void)setFruitModel:(FruitBowlModel *)fruitModel
{
    _fruitModel = fruitModel;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:fruitModel.fruit_img] placeholderImage:[UIImage imageNamed:@"gy_lifo_tray"]];
    _nameLabel.text = fruitModel.fruit_name;
    [_iconView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@90);
        make.height.equalTo(@80);
    }];
}
- (void)setXiangModel:(XiangModel *)xiangModel
{
    _xiangModel = xiangModel;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:xiangModel.xiang_img] placeholderImage:[UIImage imageNamed:@"gy_lifo_burner"]];
    _nameLabel.text = xiangModel.xiang_ming;
    [_iconView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@80);
    }];
}

- (void)setupSubViews
{
    // 图标
    self.iconView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_centerX);
        make.width.equalTo(@80);
        make.height.equalTo(@130);
    }];
    
    // 饰品名称
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont systemFontOfSize:22];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.iconView.mas_right).offset(16);
        make.height.equalTo(@30);
    }];
}

@end
