//
//  OrderDetialViewController.m
//  TTLF
//
//  Created by YRJSB on 2017/8/18.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "OrderDetialViewController.h"
#import "NormalTableViewCell.h"
#import <LCActionSheet.h>
#import "AddressTableViewCell.h"
#import <Masonry.h>

@interface OrderDetialViewController ()<UITableViewDelegate,UITableViewDataSource>

/**
 数据源
 */
@property (strong, nonatomic) GoodsOrderModel *model;
/**
 数组
 */
@property (strong, nonatomic) NSArray *array;
/**
 表格
 */
@property (strong, nonatomic) UITableView *tableView;

/**
 编辑按钮
 */
@property (strong,nonatomic) UIButton *editWuliuButton;

// 商品封面
@property (strong,nonatomic) UIImageView *goodsImgView;
// 商品名称
@property (strong,nonatomic) UILabel *goodsNameLabel;
// 商品数量
@property (strong,nonatomic) UILabel *goodsNumLabel;
// 购买时的商品单价
@property (strong,nonatomic) UILabel *goodsPriceLabel;
// 支付总额
@property (strong,nonatomic) UILabel *sumPriceLabel;

// 留言
@property (strong,nonatomic) UILabel *msgLabel;

// 物流状态
@property (strong,nonatomic) UILabel *wuliuStatusLabel;


@end

@implementation OrderDetialViewController

- (instancetype)initWithModel:(GoodsOrderModel *)orderModel
{
    self = [super init];
    if (self) {
        self.model = orderModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    // 商品详情
    // 收货地址
    // 收件人信息
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.array = @[@[@"收货地址"],@[@"商品详情",@"支付总额",@"留言"],@[@"物流信息"]];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 50)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    // 处理订单，上传物流信息
    if ([[UserInfoManager sharedManager] getUserInfo].type == 8) {
        return;
    }
    self.editWuliuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.model.status == 1) {
        self.editWuliuButton.backgroundColor = MainColor;
        [self.editWuliuButton setTitle:@"已支付->商品已发快递" forState:UIControlStateNormal];
    }else if (self.model.status == 2){
        self.editWuliuButton.backgroundColor = WarningColor;
        [self.editWuliuButton setTitle:@"已发货->顾客已签收" forState:UIControlStateNormal];
    }else if (self.model.status == 3){
        self.editWuliuButton.backgroundColor = [UIColor grayColor];
        [self.editWuliuButton setTitle:@"顾客已签收" forState:UIControlStateNormal];
    }
    [self.editWuliuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.editWuliuButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.editWuliuButton addTarget:self action:@selector(editOrderStatusAction) forControlEvents:UIControlEventTouchUpInside];
    self.editWuliuButton.frame = CGRectMake(0, self.view.height - 64 - 50, SCREEN_WIDTH, 50);
    [self.view addSubview:self.editWuliuButton];
    
}
- (void)editOrderStatusAction
{
    if (self.model.status == 1) {
        // 把已经支付的订单变为已发货
        NSArray *kuaidiArray = @[@"顺丰速运",@"圆通快递",@"中通快递",@"EMS邮政快递"];
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"选择物流商家" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                return ;
            }
            // 商品已快递，上传物流信息
            NSString *wuliuType = kuaidiArray[buttonIndex];
            [MBProgressHUD showMessage:nil];
            [[TTLFManager sharedManager].networkManager editOrderStatusWithModel:self.model WuliuType:wuliuType WuliuOrderID:@"88888888" Success:^{
                [MBProgressHUD hideHUD];
                self.editWuliuButton.backgroundColor = MainColor;
                [self.editWuliuButton setTitle:@"商品已发出" forState:UIControlStateNormal];
                if (self.OrderStatusChangedBlock) {
                    _OrderStatusChangedBlock();
                }
                
            } Fail:^(NSString *errorMsg) {
                [MBProgressHUD hideHUD];
                [self sendAlertAction:errorMsg];
            }];
        } otherButtonTitleArray:kuaidiArray];
        [sheet show];
    }else if (self.model.status == 2) {
        // 商品已签收，把状态值改为3
        [[TTLFManager sharedManager].networkManager finishOrder:self.model Success:^{
            self.model.status = 3;
            [self.tableView reloadData];
            self.editWuliuButton.backgroundColor = [UIColor grayColor];
            [self.editWuliuButton setTitle:@"顾客已签收" forState:UIControlStateNormal];
            if (self.OrderStatusChangedBlock) {
                _OrderStatusChangedBlock();
            }
        } Fail:^(NSString *errorMsg) {
            [self sendAlertAction:errorMsg];
        }];
    }
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 收货地址
        AddressTableViewCell *cell = [AddressTableViewCell sharedAddressCell:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [cell.xian removeFromSuperview];
        [cell.defaultBtn removeFromSuperview];
        cell.imageView.image = [UIImage imageNamed:@"good_address"];
        [cell.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(65);
            make.top.equalTo(cell.contentView.mas_top).offset(12);
            make.width.equalTo(@200);
            make.height.equalTo(@21);
        }];
        [cell.addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(65);
            make.right.equalTo(cell.contentView.mas_right).offset(-12);
            make.top.equalTo(cell.nameLabel.mas_bottom).offset(5);
            make.height.equalTo(@42);
        }];
        cell.model = self.model.address;
        
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            
            // 商品信息
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.iconView removeFromSuperview];
            [cell.titleLabel removeFromSuperview];
            [cell.contentView addSubview:self.goodsImgView];
            [cell.contentView addSubview:self.goodsNameLabel];
            [cell.contentView addSubview:self.goodsPriceLabel];
            [cell.contentView addSubview:self.goodsNumLabel];
            return cell;
            
        }else if (indexPath.row == 1){
            // 商品总价
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            [cell.iconView removeFromSuperview];
            [cell.titleLabel removeFromSuperview];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            [cell.contentView addSubview:self.sumPriceLabel];
            return cell;
        }else{
            // 留言
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            [cell.iconView removeFromSuperview];
            [cell.titleLabel removeFromSuperview];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            [cell.contentView addSubview:self.msgLabel];
            return cell;
        }
    }else{
        // 物流信息
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell.iconView removeFromSuperview];
        [cell.titleLabel removeFromSuperview];
        cell.textLabel.text = self.array[indexPath.section][indexPath.row];
        [cell.contentView addSubview:self.wuliuStatusLabel];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 收地人信息
        return 95;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 100;
        }else{
            return 60;
        }
    }else{
        // 物流信息
        return 60;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [UIView new];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectZero];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}

#pragma mark - 懒加载
// 商品封面
- (UIImageView *)goodsImgView
{
    if (!_goodsImgView) {
        _goodsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 60, 60)];
        [_goodsImgView sd_setImageWithURL:[NSURL URLWithString:self.model.goods.goods_logo] placeholderImage:[UIImage imageWithColor:HWRandomColor]];
    }
    return _goodsImgView;
}
// 商品名称
- (UILabel *)goodsNameLabel
{
    if (!_goodsNameLabel) {
        _goodsNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.goodsImgView.frame) + 15, 15, self.view.width - 70 - 15 - 15, 42)];
        _goodsNameLabel.text = [NSString stringWithFormat:@"%@——%@",self.model.goods.goods_name,self.model.goods.goods_name_desc];
        _goodsNameLabel.numberOfLines = 2;
        _goodsNameLabel.font = [UIFont systemFontOfSize:16];
        _goodsNameLabel.textColor = [UIColor blackColor];
    }
    return _goodsNameLabel;
}
- (UILabel *)goodsNumLabel
{
    if (!_goodsNumLabel) {
        // 商品数量
        _goodsNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width - 10 - 100, 100 - 21 - 5, 100, 21)];
        _goodsNumLabel.text = [NSString stringWithFormat:@"数量：%d件",self.model.num];
        _goodsNumLabel.textAlignment = NSTextAlignmentRight;
        _goodsNumLabel.font = [UIFont systemFontOfSize:15];
        _goodsNumLabel.textColor = [UIColor blackColor];
    }
    return _goodsNumLabel;
}
- (UILabel *)goodsPriceLabel
{
    if (!_goodsPriceLabel) {
        // 购买时的单击
        _goodsPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.goodsImgView.frame) + 10, 100 - 21 - 5, 100, 21)];
        _goodsPriceLabel.textColor = [UIColor blackColor];
        _goodsPriceLabel.textAlignment = NSTextAlignmentRight;
        _goodsPriceLabel.font = [UIFont systemFontOfSize:15];
        _goodsPriceLabel.text = [NSString stringWithFormat:@"单价：%@",self.model.price];
    }
    return _goodsPriceLabel;
}
- (UILabel *)sumPriceLabel
{
    if (!_sumPriceLabel) {
        // 支付总额
        CGFloat sumPrice = self.model.num * [[NSString stringWithFormat:@"%@",self.model.price] floatValue];
        _sumPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width - 100 - 10, 15, 100, 30)];
        _sumPriceLabel.textColor = WarningColor;
        _sumPriceLabel.font = [UIFont boldSystemFontOfSize:20];
        _sumPriceLabel.textAlignment = NSTextAlignmentRight;
        _sumPriceLabel.text = [NSString stringWithFormat:@"￥%g",sumPrice];
    }
    return _sumPriceLabel;
}
- (UILabel *)msgLabel
{
    if (!_msgLabel) {
        // 留言
        _msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, self.view.width - 100 - 10, 60)];
        _msgLabel.text = self.model.remark;
        _msgLabel.numberOfLines = 2;
        _msgLabel.font = [UIFont systemFontOfSize:14];
        _msgLabel.textColor = [UIColor grayColor];
        _msgLabel.textAlignment = NSTextAlignmentRight;
    }
    return _msgLabel;
}
- (UILabel *)wuliuStatusLabel
{
    if (!_wuliuStatusLabel) {
        _wuliuStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width - 28 - 200, 15, 200, 30)];
        if (self.model.status == 1) {
            self.wuliuStatusLabel.text = @"准备发货";
            self.wuliuStatusLabel.textColor = GreenColor;
        }else if (self.model.status == 2){
            self.wuliuStatusLabel.textColor = [UIColor brownColor];
            self.wuliuStatusLabel.text = @"商品运输中";
        }else if(self.model.status == 3){
            self.wuliuStatusLabel.text = @"订单已完成";
            self.wuliuStatusLabel.textColor = [UIColor blackColor];
        }
        self.wuliuStatusLabel.font = [UIFont systemFontOfSize:15];
        self.wuliuStatusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _wuliuStatusLabel;
}


@end
