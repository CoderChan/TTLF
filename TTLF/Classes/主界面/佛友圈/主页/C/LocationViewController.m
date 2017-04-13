//
//  LocationViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/11.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "LocationViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface LocationViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
/** 目标地位置模型 */
@property (strong,nonatomic) LocationModel *locationModel;
/** 百度地图 */
@property (strong,nonatomic) BMKMapView *mapView;
/** 定位服务 */
//@property (strong,nonatomic) BMKLocationService *locaServer;
/** 定位管理者 */
@property (strong,nonatomic) BMKGeoCodeSearch *geoSearch;
/** 大头针 */
@property (strong,nonatomic) BMKPointAnnotation *annotation;

@end

@implementation LocationViewController

- (instancetype)initWithLocation:(LocationModel *)localModel
{
    self = [super init];
    if (self) {
        self.locationModel = localModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看位置";
    [self setupSubViews];
}

- (void)setupSubViews
{
    // 反地理编码
    CGFloat latitude = [self.locationModel.latitude floatValue];
    CGFloat longitude = [self.locationModel.longitude floatValue];
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){latitude, longitude};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    self.geoSearch = [BMKGeoCodeSearch new];
    self.geoSearch.delegate = self;
    BOOL isGeoed = [self.geoSearch reverseGeoCode:reverseGeoCodeSearchOption];
    if (isGeoed) {
        [MBProgressHUD showSuccess:@"编码成功"];
    }else{
        [self openSettingWithTips:@"位置信息访问失败，请检查您是否授权'天天礼佛'地理位置访问权限。"];
    }
    
    // 地图
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 64)];
    self.mapView.delegate = self;
    self.mapView.showMapScaleBar = YES;
    self.mapView.gesturesEnabled = YES;
    self.mapView.overlookEnabled = YES;
    self.mapView.rotateEnabled = YES;
    self.mapView.showsUserLocation = YES;
//    self.mapView.compassPosition = CGPointMake(self.view.width - 60, 30);
    [self.mapView zoomIn];
    [self.mapView zoomIn];
    [self.mapView zoomIn];
    [self.mapView zoomIn];
    self.mapView.mapType = BMKMapTypeStandard;
    [self.view addSubview:self.mapView];
    
    
    // 顶部位置信息
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mapView.frame), self.view.width, 64)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
    
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    // 设置大头针
    self.annotation.coordinate = result.location;
    self.annotation.title = result.address;
    [_mapView addAnnotation:self.annotation];
    NSLog(@"onGetReverseGeoCodeResult = %@",result.address);
}

- (BMKPointAnnotation *)annotation
{
    if (!_annotation) {
        _annotation = [[BMKPointAnnotation alloc]init];
    }
    return _annotation;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    _locaServer.delegate = nil;
    _geoSearch.delegate = nil;
    _mapView.delegate = nil;
}

- (void)dealloc
{
//    _locaServer.delegate = nil;
    _geoSearch.delegate = nil;
    _mapView.delegate = nil;
}


@end
