//
//  PlaceListViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2016/12/20.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "PlaceListViewController.h"
#import "PlaceTableViewCell.h"
#import <MJRefresh.h>
#import "ProvinceViewController.h"
#import "RootNavgationController.h"
#import "PlaceDetialController.h"


@interface PlaceListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation PlaceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佛教名山";
    
    [self setupSubViews];
}
- (void)setupSubViews
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.contentInset = UIEdgeInsetsMake(4, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
    }];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"place_select_province"] style:UIBarButtonItemStylePlain target:self action:@selector(ChangeProvinceAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:MainColor];
}
- (void)ChangeProvinceAction
{
    ProvinceViewController *province = [ProvinceViewController new];
    RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:province];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}
#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 20;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PlaceTableViewCell *cell = [PlaceTableViewCell sharedDisCoverTableCell:tableView];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlaceDetialController *placeDetial = [[PlaceDetialController alloc]init];
    
    [self.navigationController pushViewController:placeDetial animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 4;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [[UIView alloc]init];
    foot.backgroundColor = [UIColor clearColor];
    return foot;
}


@end
