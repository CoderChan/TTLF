//
//  StoreVageViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/23.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "StoreVageViewController.h"
#import "VageStoreTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>
#import "VageDetialViewController.h"


@interface StoreVageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSMutableArray *array;

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation StoreVageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"素食收藏";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.array = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 15 + 30 + 15 + 110 *CKproportion + 20;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.array removeAllObjects];
        [[TTLFManager sharedManager].networkManager storeVegeListSuccess:^(NSArray *array) {
            
            self.tableView.hidden = NO;
            [self.array addObjectsFromArray:array];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
            
            self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                
            }];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        } Fail:^(NSString *errorMsg) {
            self.tableView.hidden = YES;
            [self.tableView.mj_header endRefreshing];
            [self showEmptyViewWithMessage:errorMsg];
        }];
        
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VegeInfoModel *model = self.array[indexPath.section];
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"取消收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 取消收藏
        [[TTLFManager sharedManager].networkManager cancleStoreVegeWithModel:model Success:^{
            [self.array removeObjectAtIndex:indexPath.section];
            [self.tableView reloadData];
        } Fail:^(NSString *errorMsg) {
            [MBProgressHUD showError:errorMsg];
        }];
    }];
    action.backgroundColor = WarningColor;
    return @[action];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VageStoreTableViewCell *cell = [VageStoreTableViewCell sharedVageCell:tableView];
    cell.vegeModel = self.array[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VegeInfoModel *vegeModel = self.array[indexPath.section];
    VageDetialViewController *detial = [[VageDetialViewController alloc]initWithVegeModel:vegeModel];
    [self.navigationController pushViewController:detial animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}





@end
