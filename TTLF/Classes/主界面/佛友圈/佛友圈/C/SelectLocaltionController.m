//
//  SelectLocaltionController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/2/28.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SelectLocaltionController.h"
#import "NormalTableViewCell.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>


@interface SelectLocaltionController ()<UITableViewDelegate,UITableViewDataSource,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSArray *array;

/** 菊花 */
@property (strong,nonatomic) UIActivityIndicatorView *indicatorV;
/** 我的经纬度 */
@property (strong,nonatomic) CLLocation *myLocation;
/** 我的城市 */
@property (copy,nonatomic) NSString *myCity;
/** 百度地图 */
@property (strong,nonatomic) BMKMapView *mapView;
/** 定位服务 */
@property (strong,nonatomic) BMKLocationService *locaServer;
/** POI检索 */
@property (strong,nonatomic) BMKPoiSearch *poiSearch;
/** 定位管理者 */
@property (strong,nonatomic) BMKGeoCodeSearch *geoSearch;
/** 我的位置信息 */
@property (strong,nonatomic) LocationModel *locationModel;


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
    self.tableView.rowHeight = 60;
    [self.view addSubview:self.tableView];
    
    UIView *insertView = [[UIView alloc]initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    insertView.backgroundColor = RGBACOLOR(87, 87, 87, 1);
    [self.tableView insertSubview:insertView atIndex:0];
    
    // 地图
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT - 64) * 0.34)];
    self.mapView.delegate = self;
    self.mapView.showMapScaleBar = YES;
    self.mapView.gesturesEnabled = YES;
    self.mapView.overlookEnabled = YES;
    self.mapView.rotateEnabled = YES;
    self.mapView.showsUserLocation = YES;
    [self.mapView zoomIn];
    [self.mapView zoomIn];
    [self.mapView zoomIn];
    [self.mapView zoomIn];
    [self.mapView zoomIn];
    [self.mapView zoomIn];
    self.mapView.mapType = BMKMapTypeStandard;
    self.tableView.tableHeaderView = self.mapView;
    
    // 定位信息
    _locaServer = [[BMKLocationService alloc]init];
    _locaServer.delegate = self;
    [_locaServer startUserLocationService];
    
    
}

#pragma mark - 定位代理
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    [self.indicatorV stopAnimating];
    // 我的位置的坐标
    CLLocationDegrees latitude = userLocation.location.coordinate.latitude;
    CLLocationDegrees longtude = userLocation.location.coordinate.longitude;
    _mapView.showsUserLocation = YES;
    [_mapView updateLocationData:userLocation];
    
    CLLocationCoordinate2D local2D = CLLocationCoordinate2DMake(latitude,longtude);
    [_mapView setCenterCoordinate:local2D animated:YES];
    
    // 反地理编码
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){latitude, longtude};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    self.geoSearch = [BMKGeoCodeSearch new];
    _geoSearch.delegate = self;
    BOOL flag = [_geoSearch reverseGeoCode:reverseGeoCodeSearchOption];
    
    if(flag){
        KGLog(@"反geo检索发送成功");
        self.locationModel.latitude = [NSString stringWithFormat:@"%f",latitude];;
        self.locationModel.longitude = [NSString stringWithFormat:@"%f",longtude];
        
    }else{
        [MBProgressHUD showError:@"检索失败"];
    }
    
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    [self.indicatorV stopAnimating];
    if (error == BMK_SEARCH_NO_ERROR) {
        
        self.array = result.poiList;
        [self.tableView reloadData];
        
    }else {
        [MBProgressHUD showError:@"定位失败"];
    }
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
    [cell.titleLabel removeFromSuperview];
    
    BMKPoiInfo *model = self.array[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.address;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BMKPoiInfo *model = self.array[indexPath.row];
    self.locationModel.address = model.name;
    if (self.LocationBlock) {
        _LocationBlock(self.locationModel);
        [self.navigationController popViewControllerAnimated:YES];
    }
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
- (LocationModel *)locationModel
{
    if (!_locationModel) {
        _locationModel = [[LocationModel alloc]init];
    }
    return _locationModel;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    _locaServer.delegate = self;
//    _geoSearch.delegate = self;
//    _mapView.delegate = self;
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _locaServer.delegate = nil;
    _geoSearch.delegate = nil;
    _mapView.delegate = nil;
}

- (void)dealloc
{
    _locaServer.delegate = nil;
    _geoSearch.delegate = nil;
    _mapView.delegate = nil;
}

@end
