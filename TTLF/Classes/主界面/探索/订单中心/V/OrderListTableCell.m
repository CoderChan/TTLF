//
//  OrderListTableCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "OrderListTableCell.h"
#import <Masonry.h>

@interface OrderListTableCell ()

/** 产品图标 */
@property (strong,nonatomic) UIImageView *goodImgView;
/** 日期 */
@property (strong,nonatomic) UILabel *dateLabel;
/** 商品名称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 订单号 */
@property (strong,nonatomic) UILabel *orderIDLabel;
/** 状态 */
@property (strong,nonatomic) UILabel *statusLabel;


@end

@implementation OrderListTableCell

+ (instancetype)sharedOrderListCell:(UITableView *)tableView
{
    static NSString *ID = @"OrderListTableCell";
    OrderListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[OrderListTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
//    高度160*比例
    // 商品封面
    self.goodImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iPhone_place"]];
    self.goodImgView.frame = CGRectMake(15, 30, 100*CKproportion, 100*CKproportion);
    [self.contentView addSubview:self.goodImgView];
    
    // 商品名称
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.goodImgView.frame) + 15, 80*CKproportion - 38, SCREEN_WIDTH - self.goodImgView.x - self.goodImgView.width - 15 - 20, 44)];
    self.nameLabel.text = @"商品名称商品名称商品名称商品名称商品名称商品名称商品名称";
    self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
    self.nameLabel.numberOfLines = 2;
    [self.contentView addSubview:self.nameLabel];
    
    // 日期
    self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.x, self.nameLabel.y - 21, self.nameLabel.width, 21)];
    self.dateLabel.text = @"2017年05月28";
    self.dateLabel.font = [UIFont systemFontOfSize:14];
    self.dateLabel.textColor = RGBACOLOR(87, 87, 87, 1);
    [self.contentView addSubview:self.dateLabel];
    
    // 订单ID
    self.orderIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.x, CGRectGetMaxY(self.nameLabel.frame), self.nameLabel.width, 24)];
    self.orderIDLabel.text = @"订单号#：A20170527001";
    self.orderIDLabel.font = self.dateLabel.font;
    self.orderIDLabel.textColor = RGBACOLOR(45, 45, 45, 1);
    [self.contentView addSubview:self.orderIDLabel];
    
    // 订单状态
    self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.x, CGRectGetMaxY(self.orderIDLabel.frame), self.nameLabel.width, 21)];
    self.statusLabel.text = @"状态：待支付";
    self.statusLabel.textColor = WarningColor;
    self.statusLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.statusLabel];

}

@end
