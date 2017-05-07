//
//  SearchVageViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/6.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SearchVageViewController.h"
#import "FindVageTableViewCell.h"

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
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
