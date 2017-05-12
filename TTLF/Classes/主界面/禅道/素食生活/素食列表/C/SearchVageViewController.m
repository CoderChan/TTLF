//
//  SearchVageViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/6.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SearchVageViewController.h"
#import "FindVageTableViewCell.h"
#import "VageDetialViewController.h"

@interface SearchVageViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 搜索结果集 */
@property (copy,nonatomic) NSArray *searchArray;

/** 搜索框 */
@property (strong,nonatomic) UISearchController *searchController;

@end

@implementation SearchVageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"素食搜索";
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.definesPresentationContext = YES;
    
    // 表格
    self.view.backgroundColor = BackColor;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.placeholder = @"搜索关键字";
    self.searchController.searchBar.height = 50;
    [self.searchController.searchBar becomeFirstResponder];
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
}



- (void)showEmptyWithMessage:(NSString *)message
{
    self.tableView.hidden = NO;
    [self showEmptyViewWithMessage:message];
}

#pragma mark - 搜索代理
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length < 1) {
        return;
    }
    // 搜索素食
    [[TTLFManager sharedManager].networkManager searchVege:searchBar.text Success:^(NSArray *array) {
        
        [self.searchController dismissViewControllerAnimated:YES completion:nil];
        self.searchArray = array;
        self.tableView.hidden = NO;
        [self hideMessageAction];
        [self.tableView reloadData];
    } Fail:^(NSString *errorMsg) {
        [self showEmptyWithMessage:errorMsg];
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length < 1) {
        return;
    }
    
    // 搜索素食
    [[TTLFManager sharedManager].networkManager searchVege:searchBar.text Success:^(NSArray *array) {
        
        [self.searchController dismissViewControllerAnimated:YES completion:nil];
        self.searchArray = array;
        self.tableView.hidden = NO;
        [self hideMessageAction];
        [self.tableView reloadData];
    } Fail:^(NSString *errorMsg) {
        [self showEmptyWithMessage:errorMsg];
    }];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.searchArray = nil;
    [self.tableView reloadData];
    return YES;
}

#pragma mark - 表格
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.searchArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VegeInfoModel *vegeModel = self.searchArray[indexPath.section];
    FindVageTableViewCell *cell = [FindVageTableViewCell sharedFindVageCell:tableView];
    cell.vegeModel = vegeModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VegeInfoModel *vegeModel = self.searchArray[indexPath.section];
    
    VageDetialViewController *vageDetial = [[VageDetialViewController alloc]initWithVegeModel:vegeModel];
    [self.navigationController pushViewController:vageDetial animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220*CKproportion + 10 + 25 + 28 + 50 + 10;
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

//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    [self.navigationController.navigationBar setHidden:YES];
//    
//}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    [self.navigationController.navigationBar setHidden:NO];
//}
//


@end
