//
//  PayOrderViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/29.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PayOrderViewController.h"
#import "AddressTableViewCell.h"
#import "NormalTableViewCell.h"
#import "AddressCacheManager.h"
#import <Masonry.h>
#import "AddressListViewController.h"
#import "WXApiManager.h"
#import <WXApiObject.h>


@interface PayOrderViewController ()<UITableViewDelegate,UITableViewDataSource,WXApiManagerDelegate>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 商品模型 */
@property (strong,nonatomic) GoodsInfoModel *model;
/** 是否为新订单 */
@property (assign, nonatomic) BOOL isNewOrder;
/** 商品详情 */
@property (strong,nonatomic) UIImageView *goodsImgView;
/** 商品名称 */
@property (strong,nonatomic) UILabel *goodsNameLabel;
/** 商品价格x1 */
@property (strong,nonatomic) UILabel *goodsPriceLabel;
/** 购买数量 */
@property (strong,nonatomic) UILabel *numLabel;
@property (strong,nonatomic) UIButton *addButton;
@property (strong,nonatomic) UIButton *miniteButton;
/** 我的留言 */
@property (strong,nonatomic) YYTextView *msgField;

/** 总计数量 */
@property (strong,nonatomic) UILabel *sumCountLabel;
/** 总计价格 */
@property (strong,nonatomic) UILabel *sumPriceLabel;

/** 选择支付方式--默认支付宝 */
@property (strong,nonatomic) UIImageView *zhifubaoPayIcon;
/** 选择支付方式--微信支付 */
@property (strong,nonatomic) UIImageView *wechatPayIcon;
/** 是否为微信支付 */
@property (assign,nonatomic) BOOL isWechatPay;
@property (strong, nonatomic) UIButton *sendButton;


// 收货地址模型
@property (strong,nonatomic) AddressModel *addressModel;
// 微信支付模型
@property (strong,nonatomic) WechatPayInfoModel *payModel;



@end

@implementation PayOrderViewController

- (instancetype)initWithModel:(GoodsInfoModel *)model OrderType:(BOOL)isNewOrder
{
    self = [super init];
    if (self) {
        self.model = model;
        self.isNewOrder = isNewOrder;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完成支付";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.isWechatPay = YES;
    self.array = @[@[@"收货地址"],@[@"商品详情",@"购买数量",@"我要留言"],@[@"微信支付"]];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 124)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    // 底部View
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 64 - 60, self.view.width, 60)];
    footView.backgroundColor = [UIColor whiteColor];
    footView.userInteractionEnabled = YES;
    [self.view addSubview:footView];
    // 线
    UIImageView *xian = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, footView.width, 2)];
    xian.image = [UIImage imageNamed:@"xian"];
    [footView addSubview:xian];
    
    // 总数量
    [footView addSubview:self.sumCountLabel];
    [self createSumCount:self.numLabel.text SumPrice:self.model.sale_price];
    
    // 提交订单
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setTitle:@"提交订单" forState:UIControlStateNormal];
    self.sendButton.backgroundColor = WarningColor;
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    self.sendButton.frame = CGRectMake(footView.width * 0.7, 0, footView.width * 0.3, footView.height);
    [self.sendButton addTarget:self action:@selector(payOrderAction) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:self.sendButton];
    
    
    // 收货地址
    NSArray *addressList = [[AddressCacheManager sharedManager] getAddressArray];
    for (AddressModel *model in addressList) {
        if (model.is_default) {
            self.addressModel = model;
            [self.tableView reloadData];
        }
    }
    
    // 监听支付回调
    [YLNotificationCenter addObserver:self selector:@selector(payResultAction) name:WechatPayResultNoti object:nil];
    // 从前台进入的话
//    [YLNotificationCenter addObserver:self selector:@selector(payResultAction) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void)payResultAction
{
    NSLog(@"查询微信支付结果");
    [MBProgressHUD showMessage:@"验证中···"];
    [[TTLFManager sharedManager].networkManager checkWechatPayWithModel:self.payModel Success:^{
        [MBProgressHUD hideHUD];
        [YLNotificationCenter postNotificationName:PaySuccessNoti object:nil];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    } Fail:^(NSString *errorMsg) {
        [MBProgressHUD hideHUD];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [YLNotificationCenter postNotificationName:PayFailedNoti object:errorMsg];
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
}
#pragma mark - 支付订单
- (void)payOrderAction
{
    [self.view endEditing:YES];
    
    if (!self.addressModel) {
        [MBProgressHUD showError:@"请完善收货地址"];
        return;
    }
    
    [MBProgressHUD showMessage:@"获取支付信息"];
    [[TTLFManager sharedManager].networkManager addGoodsToOrderListWithModel:self.model Nums:self.numLabel.text Remark:self.msgField.text PayType:WechatPayType PlaceModel:self.addressModel Success:^(WechatPayInfoModel *wechatPayModel) {
        [MBProgressHUD hideHUD];
        [YLNotificationCenter postNotificationName:OrderListChanged object:nil];
        self.payModel = wechatPayModel;
        [self openWechatPayWithModel:wechatPayModel];
        
    } Fail:^(NSString *errorMsg) {
        [MBProgressHUD hideHUD];
        [self showPopTipsWithMessage:errorMsg AtView:self.sendButton inView:self.view];
    }];
}

#pragma mark - 微信支付
- (void)openWechatPayWithModel:(WechatPayInfoModel *)payModel
{
    
    PayReq *req = [[PayReq alloc] init];
    
    req.partnerId = payModel.partnerid; // 商家ID
    req.prepayId = payModel.prepayid; // 预支付订单ID
    req.nonceStr = payModel.noncestr; // 随机串，防重发
    req.timeStamp = [payModel.timestamp unsignedIntValue]; // 时间戳，防重发
    req.package = payModel.package; // 商家根据财付通文档填写的数据和签名
    req.sign = payModel.sign;  // 商家根据微信开放平台文档对数据做的签名
    
    [WXApi sendReq:req];
    
    
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
        // 收货人地址
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
        cell.model = self.addressModel;
        
        return cell;
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            // 商品详情
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.iconView removeFromSuperview];
            [cell.titleLabel removeFromSuperview];
            [cell.contentView addSubview:self.goodsImgView];
            [cell.contentView addSubview:self.goodsNameLabel];
            [cell.contentView addSubview:self.goodsPriceLabel];
            return cell;
        }else if (indexPath.row == 1){
            // 数量
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.iconView removeFromSuperview];
            [cell.titleLabel removeFromSuperview];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            [cell.contentView addSubview:self.addButton];
            [cell.contentView addSubview:self.numLabel];
            [cell.contentView addSubview:self.miniteButton];
            return cell;
        }else {
            // 买家留言
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.iconView removeFromSuperview];
            [cell.titleLabel removeFromSuperview];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            [cell.contentView addSubview:self.msgField];
            return cell;
        }
        
    }else{
        if (indexPath.row == 0) {
            // 微信支付
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.iconView.image = [UIImage imageNamed:@"pay_wechat"];
            cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
            [cell.contentView addSubview:self.wechatPayIcon];
            if (self.isWechatPay) {
                _wechatPayIcon.image = [UIImage imageNamed:@"cm2_list_checkbox_ok"];
            }else{
                _wechatPayIcon.image = [UIImage imageNamed:@"cm2_list_checkbox"];
            }
            return cell;
            
        } else {
            // 支付宝
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.iconView.image = [UIImage imageNamed:@"pay_zhifubao"];
            cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
            [cell.contentView addSubview:self.zhifubaoPayIcon];
            if (self.isWechatPay) {
                _zhifubaoPayIcon.image = [UIImage imageNamed:@"cm2_list_checkbox"];
            }else{
                _zhifubaoPayIcon.image = [UIImage imageNamed:@"cm2_list_checkbox_ok"];
            }
            return cell;
        }

    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    
    if (indexPath.section == 0) {
        AddressListViewController *address = [[AddressListViewController alloc]init];
        address.SelectAddressBlock = ^(AddressModel *model) {
            self.addressModel = model;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:address animated:YES];
    }else if (indexPath.section == 1){
        
    }else {
        if (indexPath.row == 0) {
            // 微信支付
            self.isWechatPay = YES;
            [self.tableView reloadData];
            
        }else{
            // 支付宝
            self.isWechatPay = NO;
            [self.tableView reloadData];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 95;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 100;
        }else{
            return 60;
        }
    }else{
        return 60;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}


#pragma mark - 懒加载
// 留言
- (YYTextView *)msgField
{
    if (!_msgField) {
        _msgField = [[YYTextView alloc]initWithFrame:CGRectMake(95, 15, self.view.width - 100, 35)];
        _msgField.backgroundColor = [UIColor clearColor];
        _msgField.placeholderText = @"选填(您想备注的留言)";
        _msgField.placeholderFont = [UIFont systemFontOfSize:14];
        _msgField.placeholderTextColor = [UIColor lightGrayColor];
        _msgField.font = [UIFont systemFontOfSize:16];
    }
    return _msgField;
}
// 增加数量
- (UIButton *)addButton
{
    if (!_addButton) {
        __weak PayOrderViewController *copySelf = self;
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addButton setTitle:@"+" forState:UIControlStateNormal];
        _addButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
        _addButton.frame = CGRectMake(self.view.width - 55, 10, 40, 40);
        _addButton.backgroundColor = RGBACOLOR(245, 245, 245, 1);
        [_addButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            int payCount = [copySelf.numLabel.text intValue];
            payCount++;
            copySelf.miniteButton.enabled = YES;
            copySelf.numLabel.text = [NSString stringWithFormat:@"%d",payCount];
            CGFloat sumPrice = payCount * [self.model.sale_price floatValue];
            NSString *sumPriceStr = [NSString stringWithFormat:@"%.2f",sumPrice];
            [copySelf createSumCount:copySelf.numLabel.text SumPrice:sumPriceStr];
        }];
    }
    return _addButton;
}
// 购买数量
- (UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.addButton.x - 40 - 5, 10, 40, 40)];
        _numLabel.text = @"1";
        _numLabel.font = [UIFont systemFontOfSize:17];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    }
    return _numLabel;
}
// 减少数量
- (UIButton *)miniteButton
{
    if (!_miniteButton) {
        __weak PayOrderViewController *copySelf = self;
        _miniteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _miniteButton.frame = CGRectMake(self.numLabel.x - 45, 10, 40, 40);
        [_miniteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _miniteButton.enabled = NO;
        [_miniteButton setTitle:@"-" forState:UIControlStateNormal];
        _miniteButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
        _miniteButton.backgroundColor = RGBACOLOR(245, 245, 245, 1);
        [_miniteButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            int payCount = [copySelf.numLabel.text intValue];
            if (payCount == 1) {
                copySelf.miniteButton.enabled = NO;
                CGFloat sumPrice = payCount * [self.model.sale_price floatValue];
                NSString *sumPriceStr = [NSString stringWithFormat:@"%.2f",sumPrice];
                [copySelf createSumCount:@"1" SumPrice:sumPriceStr];
                return ;
            }else{
                payCount--;
                copySelf.numLabel.text = [NSString stringWithFormat:@"%d",payCount];
                CGFloat sumPrice = payCount * [self.model.sale_price floatValue];
                NSString *sumPriceStr = [NSString stringWithFormat:@"%.2f",sumPrice];
                [copySelf createSumCount:copySelf.numLabel.text SumPrice:sumPriceStr];
            }
        }];
    }
    return _miniteButton;
}
// 商品封面
- (UIImageView *)goodsImgView
{
    if (!_goodsImgView) {
        _goodsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 60, 60)];
        [_goodsImgView sd_setImageWithURL:[NSURL URLWithString:self.model.goods_logo] placeholderImage:[UIImage imageWithColor:HWRandomColor]];
    }
    return _goodsImgView;
}
// 商品名称
- (UILabel *)goodsNameLabel
{
    if (!_goodsNameLabel) {
        _goodsNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.goodsImgView.frame) + 15, 15, self.view.width - 70 - 15 - 15, 42)];
        _goodsNameLabel.text = [NSString stringWithFormat:@"%@——%@",self.model.goods_name,self.model.goods_name_desc];
        _goodsNameLabel.numberOfLines = 2;
        _goodsNameLabel.font = [UIFont systemFontOfSize:16];
        _goodsNameLabel.textColor = [UIColor blackColor];
    }
    return _goodsNameLabel;
}
// 富文本总价格
- (void)createSumCount:(NSString *)sumCount SumPrice:(NSString *)sumPrice
{
    NSString *sumString = [NSString stringWithFormat:@"共 %@ 件商品，总计：￥%@",sumCount,sumPrice];
    self.sumCountLabel.text = sumString;
    
    NSRange countRange = [self.sumCountLabel.text rangeOfString:[NSString stringWithFormat:@" %@ ",sumCount]];
    NSRange renRange = [self.sumCountLabel.text rangeOfString:@"￥"];
    NSRange priceRange = [self.sumCountLabel.text rangeOfString:sumPrice];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:sumString];
    [attributeStr beginEditing];
    
    [attributeStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:WarningColor} range:countRange];
    [attributeStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:WarningColor} range:renRange];
    [attributeStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName:WarningColor} range:priceRange];
    self.sumCountLabel.attributedText =  attributeStr;
    
}

// 商品价格
- (UILabel *)goodsPriceLabel
{
    if (!_goodsPriceLabel) {
        _goodsPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width - 200 - 15, 70, 200, 21)];
        _goodsPriceLabel.textColor = [UIColor grayColor];
        _goodsPriceLabel.textAlignment = NSTextAlignmentRight;
        _goodsPriceLabel.font = [UIFont systemFontOfSize:14];
        _goodsPriceLabel.text = [NSString stringWithFormat:@"￥%@        x 1",self.model.sale_price];
    }
    return _goodsPriceLabel;
}

// 总计x件商品
- (UILabel *)sumCountLabel
{
    if (!_sumCountLabel) {
        _sumCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, self.view.width * 0.68, 30)];
        _sumCountLabel.textAlignment = NSTextAlignmentRight;
        _sumCountLabel.font = [UIFont systemFontOfSize:15];
        _sumCountLabel.textColor = [UIColor blackColor];
    }
    return _sumCountLabel;
}
- (UIImageView *)zhifubaoPayIcon
{
    if (!_zhifubaoPayIcon) {
        _zhifubaoPayIcon = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width - 40, 19, 22, 22)];
    }
    return _zhifubaoPayIcon;
}
- (UIImageView *)wechatPayIcon
{
    if (!_wechatPayIcon) {
        _wechatPayIcon = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width - 40, 19, 22, 22)];
    }
    return _wechatPayIcon;
}
- (void)dealloc
{
    //移除通知
    [YLNotificationCenter removeObserver:self];
}
- (WechatPayInfoModel *)payModel
{
    if (!_payModel) {
        _payModel = [[WechatPayInfoModel alloc]init];
    }
    return _payModel;
}

@end
