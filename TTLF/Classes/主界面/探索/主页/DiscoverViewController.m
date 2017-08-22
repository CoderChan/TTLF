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
#import "PaySuccessController.h"
#import "RootNavgationController.h"


@interface DiscoverViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 分类数组 */
@property (copy,nonatomic) NSArray *array;
/** 订单数组 */
@property (copy,nonatomic) NSArray *orderArray;

// 菊花
@property (strong,nonatomic) UIActivityIndicatorView *actityV;
// 标题label
@property (strong,nonatomic) UILabel *titleLabel;


@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
    [self setupSubViews];
    
    [YLNotificationCenter addObserver:self selector:@selector(presentPaySuccessAction:) name:PaySuccessNoti object:nil];
    [YLNotificationCenter addObserver:self selector:@selector(presentPaySuccessAction:) name:PayFailedNoti object:nil];
}

#pragma mark - 微信支付后的验证反馈
- (void)presentPaySuccessAction:(NSNotification *)noti
{
    
    if (noti.object) {
        NSString *errorMsg = noti.object;
        [self sendAlertAction:errorMsg];
    }else{
        PaySuccessController *paySuccess = [[PaySuccessController alloc]init];
        RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:paySuccess];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }
    
    // 获取我的订单列表
    [[TTLFManager sharedManager].networkManager orderListSuccess:^(NSArray *array) {
        self.orderArray = array;
        [self.tableView reloadData];
    } Fail:^(NSString *errorMsg) {
        self.orderArray = @[];
        [self.tableView reloadData];
    }];
    
}

#pragma mark - 绘制表格
- (void)setupSubViews
{
//    self.array = @[@[@"订单中心",@"收货地址"],@[@"小叶紫檀",@"黄花梨",@"禅茶一味",@"红木饰品",@"幸运吊坠",@"佛像雕塑",@"精选配饰"]];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // 获取分类列表
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDataAction];
    }];
    self.navigationItem.titleView = self.actityV;
    [self.actityV startAnimating];
    [self getDataAction];
    
    UserInfoModel *userModel = [[UserInfoManager sharedManager] getUserInfo];
    if (userModel.type == 6 || userModel.type == 7) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Orders" style:UIBarButtonItemStylePlain target:self action:@selector(checkAllOrderAction)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    }
    
    [YLNotificationCenter addObserver:self selector:@selector(getDataAction) name:OrderListChanged object:nil];
}

- (void)getDataAction
{
    // 获取全部商品分类
    [[TTLFManager sharedManager].networkManager shopClassListSuccess:^(NSArray *array) {
        
        [self.actityV stopAnimating];
        self.navigationItem.titleView = self.titleLabel;
        self.title = @"发现";
        [self.tableView.mj_header endRefreshing];
        self.array = array;
        [self.tableView reloadData];
        
    } Fail:^(NSString *errorMsg) {
        [self.actityV stopAnimating];
        self.navigationItem.titleView = self.titleLabel;
        self.title = @"发现";
        [self.tableView.mj_header endRefreshing];
        [self sendAlertAction:errorMsg];
    }];
    
    // 获取我的订单列表
    [[TTLFManager sharedManager].networkManager orderListSuccess:^(NSArray *array) {
        self.orderArray = array;
        [self.tableView reloadData];
    } Fail:^(NSString *errorMsg) {
        self.orderArray = @[];
        [self.tableView reloadData];
    }];
    
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
        if (self.orderArray.count >= 1) {
            return 2;
        }else{
            return 1;
        }
    }else{
        return self.array.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.orderArray.count >= 1) {
            if (indexPath.row == 0) {
                // 订单中心
                OrderListTableCell *cell = [OrderListTableCell sharedOrderListCell:tableView];
                if (self.orderArray.count >= 1) {
                    GoodsOrderModel *model = [self.orderArray firstObject];
                    cell.model = model;
                }else{
                    cell.model = nil;
                }
                return cell;
            }else{
                // 地址管理
                NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
                cell.iconView.image = [UIImage imageNamed:@"good_address"];
                cell.titleLabel.text = @"地址管理";
                return cell;
            }
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
        if (self.orderArray.count >= 1) {
            if (indexPath.row == 0) {
                // 订单中心
                OrderListViewController *orderList = [[OrderListViewController alloc]initWithOrderList:self.orderArray];
                orderList.NewestOrderBlock = ^(NSArray *orderArray) {
                    self.orderArray = orderArray;
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:orderList animated:YES];
            }else{
                // 收货地址
                AddressListViewController *address = [[AddressListViewController alloc]init];
                [self.navigationController pushViewController:address animated:YES];
            }
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
        if (self.orderArray.count >= 1) {
            if (indexPath.row == 0) {
                return 160*CKproportion;
            }else{
                return 50;
            }
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

- (void)dealloc
{
    [YLNotificationCenter removeObserver:self];
}

- (UIActivityIndicatorView *)actityV
{
    if (!_actityV) {
        _actityV = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _actityV.frame = CGRectMake(0, 0, 30, 30);
    }
    return _actityV;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
        _titleLabel.text = @"发现";
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

@end
