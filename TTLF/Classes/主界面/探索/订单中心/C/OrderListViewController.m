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


@interface OrderListViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 订单数据源 */
@property (copy,nonatomic) NSArray *array;
/** 列表 */
@property (strong,nonatomic) UITableView *tableView;

@end

@implementation OrderListViewController


- (instancetype)initWithOrderList:(NSArray *)orderArray
{
    self = [super init];
    if (self) {
        self.array = orderArray;
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
            [self.tableView.mj_header endRefreshing];
            self.array = array;
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
}

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


@end
