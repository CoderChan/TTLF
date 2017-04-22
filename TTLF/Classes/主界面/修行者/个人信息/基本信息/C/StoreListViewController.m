//
//  StoreListViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/21.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "StoreListViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "StoreTableViewCell.h"
#import <LCActionSheet.h>

@interface StoreListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *array;

@end

@implementation StoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收藏";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 120;
    self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.array = [NSMutableArray array];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.array removeAllObjects];
        [[TTLFManager sharedManager].networkManager storeListSuccess:^(NSArray *array) {
            [self.array addObjectsFromArray:array];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                
            }];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } Fail:^(NSString *errorMsg) {
            [MBProgressHUD showError:errorMsg];
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
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
    NewsArticleModel *model = self.array[indexPath.section];
    StoreTableViewCell *cell = [StoreTableViewCell sharedStoreTableCell:tableView];
    cell.newsModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsArticleModel *newsModel = self.array[indexPath.section];
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"删除收藏？" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [[TTLFManager sharedManager].networkManager deleteStoreWithModel:newsModel Success:^{
                    [self.array removeObjectAtIndex:indexPath.section];
                    [self.tableView reloadData];
                } Fail:^(NSString *errorMsg) {
                    [MBProgressHUD showError:errorMsg];
                }];
            }
        } otherButtonTitles:@"确定删除", nil];
        sheet.destructiveButtonIndexSet = [NSSet setWithObjects:@1, nil];
        sheet.destructiveButtonColor = WarningColor;
        [sheet show];
    }];
    action.backgroundColor = WarningColor;
    return @[action];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [UIView new];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}


@end
