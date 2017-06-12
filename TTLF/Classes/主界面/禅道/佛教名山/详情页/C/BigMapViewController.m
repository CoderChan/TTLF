//
//  BigMapViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/13.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "BigMapViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <MAMapKit/MAAnnotation.h>
#import <UIButton+WebCache.h>
#import "PoiDetialView.h"
#import "PYPhotoBrowser.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface BigMapViewController ()<MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate,PoiViewDelegate>

/** 景区模型 */
@property (strong,nonatomic) PlaceDetialModel *placeModel;
/** 景区地图 */
@property (strong,nonatomic) MAMapView *mapView;
/** POI检索 */
@property (strong,nonatomic) AMapSearchAPI *search;
/** annotations */
@property (strong,nonatomic) NSMutableArray *annotations;
/** 装着POI模型 */
@property (strong,nonatomic) NSMutableArray *poiArray;
/** 定位管理器 */
@property (strong,nonatomic) AMapLocationManager *locationManager;
/** POI详细图 */
@property (strong,nonatomic) PoiDetialView *poiDetialView;


@end

@implementation BigMapViewController

- (id)initWithModel:(PlaceDetialModel *)placeModel
{
    self = [super init];
    if (self) {
        self.placeModel = placeModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.placeModel.scenic_name;
    [self setupSubViews];
}

- (void)setupSubViews
{
    // 地图控件
    self.mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    self.mapView.distanceFilter = 10;
    [self.mapView setZoomLevel:10 animated:YES];
    [self.view addSubview:self.mapView];
    
    // poi检索
    self.search = [[AMapSearchAPI alloc]init];
    self.search.delegate = self;
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc]init];
    request.keywords = self.placeModel.scenic_name;
    request.requireExtension = YES;
    request.cityLimit = NO;
    request.requireSubPOIs = YES;
    [self.search AMapPOIKeywordsSearch:request];
    
    // 返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    backButton.backgroundColor = RGBACOLOR(43, 45, 50, 0.5);
    backButton.frame = CGRectMake(20, 45, 36, 36);
    backButton.layer.masksToBounds = YES;
    backButton.layer.cornerRadius = 18;
    [self.view addSubview:backButton];
    
    // 定位我的位置
    UIButton *myLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myLocationBtn.frame = CGRectMake(20, self.view.height - 60, 30, 30);
    [myLocationBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
        [self.locationManager startUpdatingLocation];
        
    }];
    [myLocationBtn setImage:[UIImage imageNamed:@"map_mylocation"] forState:UIControlStateNormal];
    [self.view addSubview:myLocationBtn];
    
}
#pragma mark - 定位代理
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    [self sendAlertAction:error.localizedDescription];
}
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    [self.mapView setCenterCoordinate:location.coordinate animated:YES];
    [self.mapView setZoomLevel:15 animated:YES];
}
#pragma mark - 地图代理

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    NSArray<AMapPOI *> *pois = response.pois;
    AMapPOI *lastPoi = [pois firstObject];
    AMapGeoPoint *point = lastPoi.location;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude);
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    
    [self.poiArray addObjectsFromArray:pois];
    
    for (int i = 0; i < pois.count; i++) {
        AMapPOI *mapPOI = pois[i];
        CLLocationCoordinate2D pointCoordinate = CLLocationCoordinate2DMake(mapPOI.location.latitude, mapPOI.location.longitude);
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc]init];
        
        pointAnnotation.coordinate = pointCoordinate;
        pointAnnotation.lockedToScreen = NO;
        [self.annotations addObject:pointAnnotation];
    }
    [self.mapView addAnnotations:self.annotations];
    
}
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    self.poiDetialView.hidden = YES;
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.animatesDrop                 = YES;
        annotationView.draggable                    = YES;
        annotationView.pinColor                 = MAPinAnnotationColorGreen;
        annotationView.tag = [self.annotations indexOfObject:annotation];
        
        // 标注的信息
        AMapPOI *poiModel = [self.poiArray objectAtIndex:[self.annotations indexOfObject:annotation]];
        CGSize size = [poiModel.name boundingRectWithSize:CGSizeMake(self.view.width/2, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width + 10, 44)];
        nameLabel.text = poiModel.name;
        nameLabel.numberOfLines = 2;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:15];
        annotationView.leftCalloutAccessoryView = nameLabel;
        annotationView.rightCalloutAccessoryView = nil;
        
        return annotationView;
    }
    return nil;
}
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if ([view.reuseIdentifier isEqualToString:@"pointReuseIndetifier"]) {
        // 标注的信息
        AMapPOI *poiModel = [self.poiArray objectAtIndex:view.tag];
        
        self.poiDetialView.hidden = NO;
        self.poiDetialView.poiModel = poiModel;
    }else{
        // 点的其他地方
        self.poiDetialView.hidden = YES;
    }
    
}
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    [self sendAlertAction:error.localizedDescription];
}

#pragma mark - POIViewDelegate
- (void)poiViewWithType:(ClickType)type Model:(AMapPOI *)poiModel
{
    if (type == CallPhoneType) {
        // 打电话
        
        UIWebView *phoneWebView = [[UIWebView alloc]initWithFrame:CGRectZero];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",poiModel.tel]]];
        [phoneWebView loadRequest:request];
        
    }else if(type == ImageShowType){
        // 浏览图集
        if (poiModel.images.count == 0) {
            [MBProgressHUD showError:@"该区域暂无图集"];
        }else{
            
            NSMutableArray *tempArray = [NSMutableArray array];
            for (AMapImage *mapImage in poiModel.images) {
                [tempArray addObject:mapImage.url];
            }
            PYPhotosView *photosView = [PYPhotosView photosViewWithThumbnailUrls:tempArray originalUrls:tempArray];
            [self.view addSubview:photosView];
            
        }
    }
}


#pragma mark - 其他配置
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (AMapLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
    }
    return _locationManager;
}
- (NSMutableArray *)annotations
{
    if (!_annotations) {
        _annotations = [NSMutableArray array];
    }
    return _annotations;
}
- (NSMutableArray *)poiArray
{
    if (!_poiArray) {
        _poiArray = [NSMutableArray array];
    }
    return _poiArray;
}
- (PoiDetialView *)poiDetialView
{
    if (!_poiDetialView) {
        _poiDetialView = [[PoiDetialView alloc]initWithFrame:CGRectMake(0, self.view.height - 180, self.view.width, 180)];
        _poiDetialView.hidden = YES;
        _poiDetialView.delegate = self;
        [self.view addSubview:_poiDetialView];
    }
    return _poiDetialView;
}

@end
