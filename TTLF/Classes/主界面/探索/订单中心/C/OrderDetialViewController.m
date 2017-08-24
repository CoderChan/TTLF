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
    self.array = @[@[@"收货地址"],@[@"商品详情",@"合计总价",@"留言"],@[@"物流信息"]];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 50)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    // 处理订单，上传物流信息
    UIButton *editWuliuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editWuliuButton.backgroundColor = MainColor;
    [editWuliuButton setTitle:@"订单已操作" forState:UIControlStateNormal];
    [editWuliuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    editWuliuButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [editWuliuButton addTarget:self action:@selector(editOrderStatusAction) forControlEvents:UIControlEventTouchUpInside];
    editWuliuButton.frame = CGRectMake(0, self.view.height - 64 - 50, SCREEN_WIDTH, 50);
    [self.view addSubview:editWuliuButton];
    
}
- (void)editOrderStatusAction
{
    NSArray *kuaidiArray = @[@"顺丰速运",@"圆通快递",@"中通快递",@"EMS邮政快递"];
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"选择物流商家" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }
        NSString *wuliuType = kuaidiArray[buttonIndex];
        [MBProgressHUD showMessage:nil];
        [[TTLFManager sharedManager].networkManager editOrderStatusWithModel:self.model WuliuType:wuliuType WuliuOrderID:@"88888888" Success:^{
            [MBProgressHUD hideHUD];
            [self sendAlertAction:@"操作成功"];
        } Fail:^(NSString *errorMsg) {
            [MBProgressHUD hideHUD];
            [self sendAlertAction:errorMsg];
        }];
    } otherButtonTitleArray:kuaidiArray];
    [sheet show];
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
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell.iconView removeFromSuperview];
        cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            // 商品信息
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            [cell.iconView removeFromSuperview];
            cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
            return cell;
        }else if (indexPath.row == 1){
            // 商品总价
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            [cell.iconView removeFromSuperview];
            cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
            return cell;
        }else{
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            [cell.iconView removeFromSuperview];
            cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
            return cell;
        }
    }else{
        // 物流信息
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell.iconView removeFromSuperview];
        cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
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
        return 100;
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




@end
