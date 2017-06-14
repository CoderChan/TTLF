//
//  AllOrderViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/6/13.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AllOrderViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "OrderListTableCell.h"


@interface AllOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *array;

@property (copy,nonatomic) NSString *dateStr;

@end

@implementation AllOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部订单";
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
    
    NSDate *date = [NSDate date];
    NSDate *localDate = [date dateByAddingHours:8];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@",localDate];// 还需要+8小时
    self.dateStr = [dateStr substringWithRange:NSMakeRange(0, 10)];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.dateStr = @"2017-06-12";
        
        [[TTLFManager sharedManager].networkManager getAllOrderListWithDate:self.dateStr Success:^(NSArray *array) {
            [self.tableView.mj_header endRefreshing];
            self.array = array;
            [self.tableView reloadData];
        } Fail:^(NSString *errorMsg) {
            [self.tableView.mj_header endRefreshing];
            [self sendAlertAction:errorMsg];
        }];
        
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(selectDateAction)];
    
}
- (void)selectDateAction
{
    
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
    return 0.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}




@end
