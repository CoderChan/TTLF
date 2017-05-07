//
//  FindVageViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/23.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "FindVageViewController.h"
#import "FindVageTableViewCell.h"
#import "SearchVageViewController.h"
#import "VageDetialViewController.h"

@interface FindVageViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 搜索框 */
@property (strong,nonatomic) UISearchController *searchController;
/** 搜索结果集 */
@property (strong,nonatomic) SearchVageViewController *searchResultController;

@end

@implementation FindVageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"精选素食";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.definesPresentationContext = YES;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.bounds.size.height)];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.searchResultController = [[SearchVageViewController alloc]init];
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:self.searchResultController];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.placeholder = @"搜索关键字";
    self.searchController.searchBar.height = 50;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 15;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindVageTableViewCell *cell = [FindVageTableViewCell sharedFindVageCell:tableView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VageDetialViewController *vageDetial = [VageDetialViewController new];
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



@end
