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
#import "PlaceCacheManager.h"


@interface PlaceListViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;

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
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[TTLFManager sharedManager].networkManager randomPlaceListSuccess:^(NSArray *array) {
            [self.tableView.mj_header endRefreshing];
            self.tableView.hidden = NO;
            [self hideMessageAction];
            self.array = array;
            [self.tableView reloadData];
        } Fail:^(NSString *errorMsg) {
            [self.tableView.mj_header endRefreshing];
            self.tableView.hidden = YES;
            [self showEmptyViewWithMessage:errorMsg];
        }];
    }];
    
    NSArray *cacheArray = [[PlaceCacheManager sharedManager] getPlaceCacheArray];
    if (cacheArray.count == 0) {
        [self.tableView.mj_header beginRefreshing];
    }else{
        self.tableView.hidden = NO;
        [self hideMessageAction];
        self.array = cacheArray;
        [self.tableView reloadData];
    }
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
    }];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"place_select_province"] style:UIBarButtonItemStylePlain target:self action:@selector(ChangeProvinceAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    
}
- (void)ChangeProvinceAction
{
    ProvinceViewController *province = [ProvinceViewController new];
    RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:province];
    province.SelectProvinceBlock = ^(AreaDetialModel *areaModel) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:areaModel.province_name style:UIBarButtonItemStylePlain target:self action:@selector(ChangeProvinceAction)];
//        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]} forState:UIControlStateNormal];
        // 刷新界面
        [[TTLFManager sharedManager].networkManager placeListWithModel:areaModel Success:^(NSArray *array) {
            self.tableView.hidden = NO;
            [self hideMessageAction];
            self.array = array;
            [self.tableView reloadData];
        } Fail:^(NSString *errorMsg) {
            self.tableView.hidden = YES;
            [self showEmptyViewWithMessage:errorMsg];
        }];
    };
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
}
#pragma mark - 表格相关
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
    PlaceDetialModel *placeModel = self.array[indexPath.section];
    PlaceTableViewCell *cell = [PlaceTableViewCell sharedDisCoverTableCell:tableView];
    cell.placeModel = placeModel;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlaceDetialModel *placeModel = self.array[indexPath.section];
    PlaceDetialController *placeDetial = [[PlaceDetialController alloc]initWithPlaceModel:placeModel];
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
