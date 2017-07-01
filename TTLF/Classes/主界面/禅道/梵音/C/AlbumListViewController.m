//
//  AlbumListViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/6/19.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AlbumListViewController.h"
#import "PlayingRightBarView.h"
#import "MusicPlayingController.h"
#import "AlumListTableCell.h"
#import "AlbumHeadView.h"
#import <MJRefresh/MJRefresh.h>
#import "RootNavgationController.h"


@interface AlbumListViewController ()<UITableViewDelegate,UITableViewDataSource>
// 表格
@property (strong,nonatomic) UITableView *tableView;
// 分类模型
@property (strong,nonatomic) MusicCateModel *cateModel;
// 数据源
@property (copy,nonatomic) NSArray *array;
// 头部
@property (strong,nonatomic) AlbumHeadView *headView;

@end

@implementation AlbumListViewController


- (instancetype)initWithModel:(MusicCateModel *)cateModel
{
    self = [super init];
    if (self) {
        self.cateModel = cateModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专辑列表";
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    // 表格
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[TTLFManager sharedManager].networkManager albumListByModel:self.cateModel Success:^(NSArray *array) {
            
            [self.tableView.mj_header endRefreshing];
            [self hideMessageAction];
            self.array = array;
            // 头部
            self.tableView.tableHeaderView = self.headView;
            [self.tableView reloadData];
            
        } Fail:^(NSString *errorMsg) {
            [self.tableView.mj_header endRefreshing];
            [self showEmptyViewWithMessage:errorMsg];
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    
    
}
- (AlbumHeadView *)headView
{
    if (!_headView) {
        _headView = [[AlbumHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
        _headView.model = self.cateModel;
    }
    return _headView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumInfoModel *model = self.array[indexPath.row];
    model.index = indexPath.row + 1;
    AlumListTableCell *cell = [AlumListTableCell sharedAlumCell:tableView];
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MusicPlayingController *play = [[MusicPlayingController alloc]initWithArray:self.array CurrentIndex:indexPath.row];
    [self.navigationController pushViewController:play animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}


@end
