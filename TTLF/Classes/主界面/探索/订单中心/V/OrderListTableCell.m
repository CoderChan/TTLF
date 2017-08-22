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
/** 查看物流 */
@property (strong, nonatomic) UIButton *wuliuButton;

// 没有订单时的提示
@property (strong,nonatomic) UILabel *emptyLabel;

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

- (void)setModel:(GoodsOrderModel *)model
{
    if (!model) {
        // 没有订单的UI显示
        self.goodImgView.image = nil;
        self.emptyLabel.hidden = NO;
        self.wuliuButton.hidden = YES;
        self.nameLabel.text = nil;
        self.dateLabel.text = nil;
        self.orderIDLabel.text = nil;
        self.statusLabel.text = nil;
        
        self.emptyLabel.text = @"您还没有订单数据";
    }else{
        // 有订单的UI界面
        _model = model;
        _wuliuButton.hidden = YES;
        self.emptyLabel.hidden = YES;
        [_goodImgView sd_setImageWithURL:[NSURL URLWithString:model.goods.goods_logo] placeholderImage:[UIImage imageNamed:@"goods_place"]];
        _nameLabel.text = [NSString stringWithFormat:@"%@--%@",model.goods.goods_name,model.goods.goods_name_desc];
        _dateLabel.text = model.status_time;
        _orderIDLabel.text = [NSString stringWithFormat:@"订单号#：%@",model.ordernum];
        
        if (model.status == 0) {
            // 未支付
            _statusLabel.text = @"状态：待支付";
            _statusLabel.textColor = WarningColor;
        }else if (model.status == 1){
            // 已支付，准备发货中
            _wuliuButton.hidden = NO;
            _statusLabel.text = @"状态：已支付，准备发货中";
            _statusLabel.textColor = GreenColor;
        }else if(model.status == 2){
            // 商品运输中，显示查看物流按钮
            _wuliuButton.hidden = NO;
            _statusLabel.text = @"状态：商品运输中";
            _statusLabel.textColor = GreenColor;
        }else if (model.status == 3){
            // 已完成
            _statusLabel.text = @"状态：已完成";
            _statusLabel.textColor = GreenColor;
        }else{
            // 未知
            _statusLabel.text = @"未知状态";
            _statusLabel.textColor = WarningColor;
        }
    }
}

- (void)setupSubViews
{
//    高度160*比例
    // 商品封面
    self.goodImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goods_place"]];
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
    
    // 查看物流
//    self.wuliuButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.wuliuButton.frame = CGRectMake(SCREEN_WIDTH - 70, 160*CKproportion - 35, 65, 30);
//    [self.wuliuButton setTitle:@"查看物流" forState:UIControlStateNormal];
//    self.wuliuButton.backgroundColor = GreenColor;
//    [self.wuliuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.layer.cornerRadius = 4;
//    self.wuliuButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    [self.wuliuButton addTarget:self action:@selector(wuliuInfoAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:self.wuliuButton];
    
}
- (void)wuliuInfoAction
{
    
}
- (UILabel *)emptyLabel
{
    if (!_emptyLabel) {
        _emptyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 160*CKproportion/2 - 20, SCREEN_WIDTH - 40, 40)];
        _emptyLabel.textColor = [UIColor grayColor];
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.font = [UIFont boldSystemFontOfSize:24];
        _emptyLabel.hidden = YES;
        [self addSubview:_emptyLabel];
        
    }
    return _emptyLabel;
}

@end
