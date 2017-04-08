//
//  SelectLocaltionController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/2/28.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SelectLocaltionController.h"
#import "NormalTableViewCell.h"
#import <BaiduMapKit/BaiduMapAPI_Map/BMKMapView.h>


@interface SelectLocaltionController ()<UITableViewDelegate,UITableViewDataSource,BMKMapViewDelegate>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;

/** 菊花 */
@property (strong,nonatomic) UIActivityIndicatorView *indicatorV;
/** 我的经纬度 */
@property (strong,nonatomic) CLLocation *myLocation;
/** 我的城市 */
@property (copy,nonatomic) NSString *myCity;
/** 百度地图 */
@property (strong,nonatomic) BMKMapView *mapView;


@end

@implementation SelectLocaltionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择位置";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.indicatorV];
    [self.indicatorV startAnimating];
    
    // 表格
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.rowHeight = 50;
    [self.view addSubview:self.tableView];
    
    UIView *insertView = [[UIView alloc]initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    insertView.backgroundColor = RGBACOLOR(87, 87, 87, 1);
    [self.tableView insertSubview:insertView atIndex:0];
    
    // 地图
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT - 64) * 0.38)];
    self.mapView.delegate = self;
    self.tableView.tableHeaderView = self.mapView;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell.iconView removeFromSuperview];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [UIView new];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

- (UIActivityIndicatorView *)indicatorV
{
    if (!_indicatorV) {
        _indicatorV = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 21, 30, 30)];
        _indicatorV.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    return _indicatorV;
}
- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _mapView.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _mapView.delegate = nil;
}

@end
