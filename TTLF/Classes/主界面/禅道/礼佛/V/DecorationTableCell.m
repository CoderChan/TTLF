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
    [_iconView sd_setImageWithURL:[NSURL URLWithString:flowerModel.flower_img] placeholderImage:[UIImage imageNamed:@"icon_place"]];
    _nameLabel.text = flowerModel.flower_name;
}
- (void)setFruitModel:(FruitBowlModel *)fruitModel
{
    _fruitModel = fruitModel;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:fruitModel.fruit_img] placeholderImage:[UIImage imageNamed:@"icon_place"]];
    _nameLabel.text = fruitModel.fruit_name;
}
- (void)setXiangModel:(XiangModel *)xiangModel
{
    _xiangModel = xiangModel;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:xiangModel.xiang_img] placeholderImage:[UIImage imageNamed:@"icon_place"]];
    _nameLabel.text = xiangModel.xiang_ming;
}

- (void)setupSubViews
{
    self.iconView = [[UIImageView alloc]initWithImage:[UIImage imageWithColor:HWRandomColor]];
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(20);
        make.width.equalTo(@80);
        make.height.equalTo(@130);
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont systemFontOfSize:22];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.iconView.mas_right).offset(20);
        make.height.equalTo(@30);
    }];
}

@end
