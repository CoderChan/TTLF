//
//  OrderListViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderListTableCell.h"
#import <MJRefresh/MJRefresh.h>
#import "OrderDetialViewController.h"
#import "PayOrderViewController.h"
#import "ServersViewController.h"


@interface OrderListViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 订单数据源 */
@property (strong,nonatomic) NSMutableArray *array;
/** 列表 */
@property (strong,nonatomic) UITableView *tableView;

@end

@implementation OrderListViewController


- (instancetype)initWithOrderList:(NSArray *)orderArray
{
    self = [super init];
    if (self) {
        self.array = orderArray.mutableCopy;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.rowHeight = 160*CKproportion;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[TTLFManager sharedManager].networkManager orderListSuccess:^(NSArray *array) {
            
            [self.array removeAllObjects];
            [self hideMessageAction];
            [self.tableView.mj_header endRefreshing];
            [self.array addObjectsFromArray:array];
            if (self.NewestOrderBlock) {
                _NewestOrderBlock(self.array);
            }
            [self.tableView reloadData];
        } Fail:^(NSString *errorMsg) {
            [self.tableView.mj_header endRefreshing];
            [self sendAlertAction:errorMsg];
        }];
    }];
    
    if (self.array.count >= 1) {
        [self.tableView reloadData];
    }else{
        [self showEmptyViewWithMessage:@"您还没有订单数据"];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"客服" style:UIBarButtonItemStylePlain target:self action:@selector(kefuAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
}

- (void)kefuAction
{
    ServersViewController *server = [[ServersViewController alloc]init];
    [self.navigationController pushViewController:server animated:YES];
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsOrderModel *model = self.array[indexPath.row];
    OrderListTableCell *cell = [OrderListTableCell sharedOrderListCell:tableView];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsOrderModel *model = self.array[indexPath.row];
    if (model.status == 0) {
        PayOrderViewController *payOrder = [[PayOrderViewController alloc]initWithModel:model.goods OrderType:NO];
        [self.navigationController pushViewController:payOrder animated:YES];
    }else{
        OrderDetialViewController *order = [[OrderDetialViewController alloc]initWithModel:model];
        [self.navigationController pushViewController:order animated:YES];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsOrderModel *model = self.array[indexPath.row];
    if (model.status == 0) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger index = indexPath.row;
    GoodsOrderModel *model = self.array[indexPath.row];
    if (model.status == 0) {
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            [[TTLFManager sharedManager].networkManager deleteUnPayOrder:model Success:^{
                [self.array removeObjectAtIndex:index];
                [self.tableView reloadData];
                if (self.NewestOrderBlock) {
                    _NewestOrderBlock(self.array);
                }
            } Fail:^(NSString *errorMsg) {
                [self sendAlertAction:errorMsg];
            }];
            
        }];
        action.backgroundColor = WarningColor;
        return @[action];
    }else{
        return NULL;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
@end
