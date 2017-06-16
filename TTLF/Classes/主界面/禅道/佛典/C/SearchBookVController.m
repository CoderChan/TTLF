//
//  SearchBookVController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/6/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SearchBookVController.h"
#import "NormalTableViewCell.h"
#import "BookStoreTableViewCell.h"
#import "BookDetialViewController.h"

@interface SearchBookVController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    BOOL isNodata;  //没有搜索结果时
}
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 搜索结果集 */
@property (copy,nonatomic) NSArray *searchArray;

/** 搜索框 */
@property (strong,nonatomic) UISearchController *searchController;

@end

@implementation SearchBookVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佛典搜索";
    [self setupSubViews];
}

- (void)setupSubViews
{
    isNodata = YES;
    
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
    self.searchController.searchBar.placeholder = @"佛典关键字";
    self.searchController.searchBar.height = 50;
    [self.searchController.searchBar becomeFirstResponder];
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
}



- (void)showMessageView:(NSString *)message
{
    [MBProgressHUD showError:message];
}

#pragma mark - 搜索代理
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length < 1) {
        return;
    }
    // 搜索佛典
    [[TTLFManager sharedManager].networkManager searchBookByKeyWord:searchBar.text Success:^(NSArray *array) {
        
        isNodata = NO;
        [self.searchController dismissViewControllerAnimated:YES completion:nil];
        self.searchArray = array;
        [self.tableView reloadData];
        
    } Fail:^(NSString *errorMsg) {
        isNodata = YES;
        [self showMessageView:errorMsg];
    }];
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    if (searchBar.text.length < 1) {
//        return;
//    }
//    
//    // 搜索佛典
//    [[TTLFManager sharedManager].networkManager searchBookByKeyWord:searchBar.text Success:^(NSArray *array) {
//        [self.searchController dismissViewControllerAnimated:YES completion:nil];
//        self.searchArray = array;
//        isNodata = NO;
//        [self.tableView reloadData];
//    } Fail:^(NSString *errorMsg) {
//        isNodata = YES;
//        [self showMessageView:errorMsg];
//    }];
//    
//}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.searchArray = nil;
    isNodata = YES;
    [self.tableView reloadData];
    return YES;
}

#pragma mark - 表格
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isNodata) {
        return 1;
    }else{
        return self.searchArray.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isNodata) {
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell.titleLabel removeFromSuperview];
        [cell.iconView removeFromSuperview];
        cell.backgroundColor = self.view.backgroundColor;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        BookInfoModel *bookModel = self.searchArray[indexPath.section];
        BookStoreTableViewCell *cell = [BookStoreTableViewCell sharedBookStoreCell:tableView];
        cell.model = bookModel;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!isNodata) {
        BookInfoModel *vegeModel = self.searchArray[indexPath.section];
        BookDetialViewController *vageDetial = [[BookDetialViewController alloc]initWithModel:vegeModel];
        [self.navigationController pushViewController:vageDetial animated:YES];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isNodata) {
        return self.view.height - 50;
    }else{
        return 120;
    }
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
