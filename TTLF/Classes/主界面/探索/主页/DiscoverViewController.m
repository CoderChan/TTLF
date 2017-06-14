//
//  DiscoverViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2016/11/24.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "DiscoverViewController.h"
#import "NormalTableViewCell.h"
#import "OrderListTableCell.h"
#import "GoodsListTableCell.h"
#import "OrderListViewController.h"
#import "AddressListViewController.h"
#import "GoodClassListController.h"
#import <MJRefresh/MJRefresh.h>
#import "AllOrderViewController.h"

@interface DiscoverViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 分类数组 */
@property (copy,nonatomic) NSArray *array;


@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
    [self setupSubViews];
    
}
#pragma mark - 绘制表格
- (void)setupSubViews
{
//    self.array = @[@[@"订单中心",@"收货地址"],@[@"小叶紫檀",@"黄花梨",@"禅茶一味",@"红木饰品",@"幸运吊坠",@"佛像雕塑",@"精选配饰"]];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // 获取分类列表
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[TTLFManager sharedManager].networkManager shopClassListSuccess:^(NSArray *array) {
            [self.tableView.mj_header endRefreshing];
            self.array = array;
            [self.tableView reloadData];
            
        } Fail:^(NSString *errorMsg) {
            [self.tableView.mj_header endRefreshing];
            [self sendAlertAction:errorMsg];
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    UserInfoModel *userModel = [[UserInfoManager sharedManager] getUserInfo];
    if (userModel.type == 6 || userModel.type == 7) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"订单" style:UIBarButtonItemStylePlain target:self action:@selector(checkAllOrderAction)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    }
    
}
- (void)checkAllOrderAction
{
    AllOrderViewController *allOrder = [AllOrderViewController new];
    [self.navigationController pushViewController:allOrder animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else{
        return self.array.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 订单中心
            OrderListTableCell *cell = [OrderListTableCell sharedOrderListCell:tableView];
            
            return cell;
        }else{
            // 地址管理
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            cell.iconView.image = [UIImage imageNamed:@"good_address"];
            cell.titleLabel.text = @"地址管理";
            return cell;
        }
    }else{
        // 商品分类
        GoodsListTableCell *cell = [GoodsListTableCell sharedGoodsListTableCell:tableView];
        GoodsClassModel *model = self.array[indexPath.row];
        cell.cateModel = model;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 订单中心
            OrderListViewController *orderList = [[OrderListViewController alloc]init];
            [self.navigationController pushViewController:orderList animated:YES];
        }else{
            // 收货地址
            AddressListViewController *address = [[AddressListViewController alloc]init];
            [self.navigationController pushViewController:address animated:YES];
        }
    } else {
        // 产品分类列表
        GoodsClassModel *model = self.array[indexPath.row];
        GoodClassListController *goodClass = [[GoodClassListController alloc]initWithModel:model];
        [self.navigationController pushViewController:goodClass animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 160*CKproportion;
        }else{
            return 50;
        }
    }else{
        return 150;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 15;
    }else{
        return 5;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [UIView new];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}


@end
