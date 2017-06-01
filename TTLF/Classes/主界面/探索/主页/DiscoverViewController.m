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

@interface DiscoverViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数组 */
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
    self.array = @[@[@"订单中心",@"收货地址"],@[@"小叶紫檀",@"黄花梨",@"菩提",@"红木饰品",@"幸运吊坠",@"佛像雕塑",@"精选配饰"]];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}
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
        if (indexPath.row == 0) {
            OrderListTableCell *cell = [OrderListTableCell sharedOrderListCell:tableView];
            
            return cell;
        }else{
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            cell.iconView.image = [UIImage imageNamed:@"good_address"];
            cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
            return cell;
        }
    }else{
        GoodsListTableCell *cell = [GoodsListTableCell sharedGoodsListTableCell:tableView];
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
        GoodClassListController *goodClass = [[GoodClassListController alloc]init];
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
