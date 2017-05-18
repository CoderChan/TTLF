//
//  GoodsListTableCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "GoodsListTableCell.h"
#import <Masonry.h>

@interface GoodsListTableCell ()

/** 商品分类封面 */
@property (strong,nonatomic) UIImageView *goodsImgView;
/** 商品分类标题 */
@property (strong,nonatomic) UILabel *goodsClassLabel;

@end

@implementation GoodsListTableCell

+ (instancetype)sharedGoodsListTableCell:(UITableView *)tableView
{
    static NSString *ID = @"GoodsListTableCell";
    GoodsListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[GoodsListTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    // 商品分类的封面图
    self.goodsImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mac_place"]];
    [self.contentView addSubview:self.goodsImgView];
    [self.goodsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_centerX).offset(20);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    // 商品分类的名称
    self.goodsClassLabel = [[UILabel alloc]init];
    self.goodsClassLabel.text = @"MacBook Pro";
    self.goodsClassLabel.font = [UIFont systemFontOfSize:19];
    [self.contentView addSubview:self.goodsClassLabel];
    [self.goodsClassLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.mas_centerX).offset(17);
        make.height.equalTo(@30);
    }];
}

@end
