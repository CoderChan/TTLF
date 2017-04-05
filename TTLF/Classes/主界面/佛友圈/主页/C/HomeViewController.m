//
//  HomeViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/1/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "HomeViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "FYQImgTableViewCell.h"
#import "CommentViewController.h"
#import "NewsHeadView.h"


@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 今日头条 */
@property (strong,nonatomic) NewsHeadView *headView;

@end



@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佛友圈";
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }];
    
    self.headView = [[NewsHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 220)];
    self.headView.userModel = [[TTLFManager sharedManager].userManager getUserInfo];
    self.tableView.tableHeaderView = self.headView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FYQImgTableViewCell *cell = [FYQImgTableViewCell sharedFYQImgTableViewCell:tableView];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CommentViewController *comment = [CommentViewController new];
    [self.navigationController pushViewController:comment animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 380;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 108)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = self.view.backgroundColor;
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.headView.userModel = [[TTLFManager sharedManager].userManager getUserInfo];
}


@end
