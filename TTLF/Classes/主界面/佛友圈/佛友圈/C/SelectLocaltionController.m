//
//  SelectLocaltionController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/2/28.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SelectLocaltionController.h"
#import "NormalTableViewCell.h"


@interface SelectLocaltionController ()<UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;
/** 地图 */
@property (strong,nonatomic) MAMapView *mapView;
/** 反地理编码 */
@property (strong,nonatomic) AMapSearchAPI *search;
/** 定位器 */
@property (strong,nonatomic) AMapLocationManager *locationManager; // 定位器;
/** 菊花 */
@property (strong,nonatomic) UIActivityIndicatorView *indicatorV;
/** 我的经纬度 */
@property (strong,nonatomic) CLLocation *myLocation;
/** 我的城市 */
@property (copy,nonatomic) NSString *myCity;


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
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT - 64) * 0.38)];
    topView.userInteractionEnabled = YES;
    self.tableView.tableHeaderView = topView;
    
    self.mapView = [[MAMapView alloc]initWithFrame:topView.bounds];
    self.mapView.showsUserLocation = YES;
    self.mapView.userLocation.title = [[TTLFManager sharedManager].userManager getUserInfo].nickName;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    [topView addSubview:self.mapView];
    
    
    self.locationManager = [[AMapLocationManager alloc]init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            [self.indicatorV stopAnimating];
            [self sendAlertAction:error.localizedDescription];
            if (error.code == AMapLocationErrorLocateFailed) {
                return ;
            }
        }else{
            // 反地理编码
            AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
            self.myLocation = location;
            CGFloat latitude = location.coordinate.latitude;
            CGFloat logitude = location.coordinate.longitude;
            regeo.location = [AMapGeoPoint locationWithLatitude:latitude longitude:logitude];
            regeo.requireExtension = YES;
            
            _search = [[AMapSearchAPI alloc]init];
            _search.delegate = self;
            [_search AMapReGoecodeSearch:regeo];
        }
    }];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    AMapReGeocode *reGeocode = response.regeocode;
    if (reGeocode) {
        [self.indicatorV stopAnimating];
        self.myCity = [NSString stringWithFormat:@"%@%@",reGeocode.addressComponent.province,reGeocode.addressComponent.city];
        for (AMapPOI *poiModel in reGeocode.pois) {
            [self.array addObject:poiModel];
        }
        AMapPOI *firstPOI = [AMapPOI new];
        firstPOI.name = self.myCity;
        firstPOI.address = self.myCity;
        AMapGeoPoint *geopoint = [AMapGeoPoint locationWithLatitude:self.myLocation.coordinate.latitude longitude:self.myLocation.coordinate.longitude];
        firstPOI.location = geopoint;
        [self.array insertObject:firstPOI atIndex:0];
        [self.tableView reloadData];
    }else{
        [self.indicatorV stopAnimating];
        [MBProgressHUD showError:@"定位失败，请检查权限"];
    }
}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [self.indicatorV stopAnimating];
    [MBProgressHUD showError:error.localizedDescription];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapPOI *poiModel = self.array[indexPath.row];
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell.iconView removeFromSuperview];
    cell.textLabel.text = poiModel.name;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AMapPOI *poiModel = self.array[indexPath.row];
    if (self.SelectPOIBlock) {
        _SelectPOIBlock(poiModel);
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
- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

@end
