//
//  SearchVageViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/6.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SearchVageViewController.h"
#import "FindVageTableViewCell.h"
#import "RootNavgationController.h"
#import "VageDetialViewController.h"

@interface SearchVageViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;



@end

@implementation SearchVageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"素食搜索";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.view.backgroundColor = BackColor;
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)setSearchArray:(NSArray *)searchArray
{
    _searchArray = searchArray;
    self.tableView.hidden = NO;
    [self hideMessageAction];
    [self.tableView reloadData];
}

- (void)showEmptyWithMessage:(NSString *)message
{
    self.tableView.hidden = YES;
    [self showEmptyViewWithMessage:message];
}

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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VegeInfoModel *vegeModel = self.searchArray[indexPath.section];
    
    VageDetialViewController *vageDetial = [[VageDetialViewController alloc]initWithVegeModel:vegeModel];
    vageDetial.isPresent = YES;
    RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:vageDetial];
    [self presentViewController:nav animated:NO completion:^{
        
    }];
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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}


@end
