//
//  PlaceDetialController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/26.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PlaceDetialController.h"
#import "NoDequeTableViewCell.h"
#import "RightMoreView.h"
#import "XLPhotoBrowser.h"
#import <MapKit/MapKit.h>
#import "ImageTableViewCell.h"
#import "BigMapViewController.h"
#import "PlacePicturesController.h"
#import "PlaceDiscussController.h"
#import <MAMapKit/MAMapKit.h>


@interface PlaceDetialController ()<UITableViewDelegate,UITableViewDataSource,RightMoreViewDelegate,MAMapViewDelegate>
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 景点模型 */
@property (strong,nonatomic) PlaceDetialModel *placeModel;

/** 封面 */
@property (strong,nonatomic) UIImageView *coverImgView;
/** 查看点评 */
@property (strong,nonatomic) UILabel *commentLabel;
/** 旅行攻略 */
@property (strong,nonatomic) UILabel *travelLabel;
/** 开放时间 */
@property (strong,nonatomic) UILabel *openTimeLabel;
/** 高德地图 */
@property (strong,nonatomic) MAMapView *mapView;
/** 电话 */
@property (strong,nonatomic) UILabel *phoneLabel;
/** 地址 */
@property (strong,nonatomic) UILabel *addressLabel;
/** 门票 */
@property (strong,nonatomic) UILabel *ticketLabel;


@end

@implementation PlaceDetialController


- (instancetype)initWithPlaceModel:(PlaceDetialModel *)placeModel
{
    self = [super init];
    if (self) {
        self.placeModel = placeModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.placeModel.place_name;
    [self setupSubViews];
    
}

- (void)setupSubViews
{

    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(moreAction)];
    
    self.array = @[@[@"封面",@"精彩游记见闻"],@[@"旅行攻略",@"开放时间"],@[@"电话：",@"地址：",@"门票："]];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = self.mapView;
    
}
#pragma mark - 其他方法
- (void)moreAction
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    RightMoreView *moreView = [[RightMoreView alloc]initWithFrame:keyWindow.bounds];
    moreView.title = @"一键分享，让名刹香火更旺";
    moreView.delegate = self;
    [keyWindow addSubview:moreView];
}
- (void)rightMoreViewWithClickType:(MoreItemClickType)clickType
{
    
}
#pragma mark - 地图相关
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    BigMapViewController *mapVC = [[BigMapViewController alloc]init];
    [self.navigationController pushViewController:mapVC animated:YES];
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 封面
            ImageTableViewCell *cell = [ImageTableViewCell sharedImageCell:tableView];
            cell.image_url = self.placeModel.place_img;
            return cell;
        } else {
            // 查看点评
            NoDequeTableViewCell *cell = [NoDequeTableViewCell sharedCell:tableView];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:19];
            cell.textLabel.textColor = MainColor;
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            return cell;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            // 旅行攻略
            NoDequeTableViewCell *cell = [NoDequeTableViewCell sharedCell:tableView];
            [cell.contentView addSubview:self.travelLabel];
            return cell;
        } else {
            // 开放时间
            NoDequeTableViewCell *cell = [NoDequeTableViewCell sharedCell:tableView];
            [cell.contentView addSubview:self.openTimeLabel];
            return cell;
        }
    }else{
        if (indexPath.row == 0) {
            // 电话
            NoDequeTableViewCell *cell = [NoDequeTableViewCell sharedCell:tableView];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.contentView addSubview:self.phoneLabel];
            return cell;
        }else if (indexPath.row == 1){
            // 地址
            NoDequeTableViewCell *cell = [NoDequeTableViewCell sharedCell:tableView];
            [cell.contentView addSubview:self.addressLabel];
            return cell;
        }else {
            // 门票
            NoDequeTableViewCell *cell = [NoDequeTableViewCell sharedCell:tableView];
            [cell.contentView addSubview:self.ticketLabel];
            return cell;
        }
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 预览图集
            PlacePicturesController *picture = [[PlacePicturesController alloc]init];
            [self.navigationController pushViewController:picture animated:YES];
        }else{
            // 评论界面
            PlaceDiscussController *discuss = [[PlaceDiscussController alloc]init];
            [self.navigationController pushViewController:discuss animated:YES];
        }
    }else if (indexPath.section == 1){
        
    }else {
        if (indexPath.row == 0) {
            // 电话
//            UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
//            NSURL *url = [NSURL URLWithString:self.placeModel.mobie];
//            [webView loadRequest:[NSURLRequest requestWithURL:url]];
//            [self.view addSubview:webView];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 封面
            return 220 * CKproportion;
        } else {
            // 查看点评
            return 55;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            // 旅行攻略
            NSString *travelStr = [NSString stringWithFormat:@"旅行攻略：%@",self.placeModel.place_travel];
            CGFloat height = [travelStr boundingRectWithSize:CGSizeMake(self.view.width - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height + 20;
            return height;
        } else {
            // 开放时间
            NSString *timeStr = [NSString stringWithFormat:@"开放时间：%@",self.placeModel.open_time];
            CGFloat height = [timeStr boundingRectWithSize:CGSizeMake(self.view.width - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height + 20;
            return height;
        }
    }else{
        if (indexPath.row == 0) {
            // 电话
            return 50;
        }else if (indexPath.row == 1){
            // 地址
            NSString *addressStr = [NSString stringWithFormat:@"地址：%@",self.placeModel.address];
            CGFloat height = [addressStr boundingRectWithSize:CGSizeMake(self.view.width - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height + 30;
            return height;
        }else {
            // 门票
            NSString *ticketStr = [NSString stringWithFormat:@"门票：%@",self.placeModel.ticket];
            CGFloat height = [ticketStr boundingRectWithSize:CGSizeMake(self.view.width - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
            return height + 20;
        }
    }
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

#pragma mark - 懒加载
// 封面
- (UIImageView *)coverImgView
{
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 180*CKproportion)];
        _coverImgView.contentMode = UIViewContentModeScaleAspectFill;
        [_coverImgView setContentScaleFactor:[UIScreen mainScreen].scale];
        _coverImgView.layer.masksToBounds = YES;
        _coverImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight & UIViewAutoresizingFlexibleWidth;
        _coverImgView.backgroundColor = [UIColor clearColor];
        _coverImgView.userInteractionEnabled = YES;
    }
    return _coverImgView;
}
// 旅行攻略
- (UILabel *)travelLabel
{
    if (!_travelLabel) {
        NSString *travelStr = [NSString stringWithFormat:@"旅行攻略：%@",self.placeModel.place_travel];
        CGFloat height = [travelStr boundingRectWithSize:CGSizeMake(self.view.width - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
        _travelLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.width - 30, height + 20)];
        _travelLabel.text = travelStr;
        _travelLabel.textColor = RGBACOLOR(65, 65, 65, 1);
        _travelLabel.font = [UIFont systemFontOfSize:17];
        _travelLabel.numberOfLines = 0;
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:travelStr];
        [attributeStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName:MainColor} range:NSMakeRange(0, 5)];
        _travelLabel.attributedText = attributeStr;
    }
    return _travelLabel;
}
// 开放时间
- (UILabel *)openTimeLabel
{
    if (!_openTimeLabel) {
        NSString *timeStr = [NSString stringWithFormat:@"开放时间：%@",self.placeModel.open_time];
        CGFloat height = [timeStr boundingRectWithSize:CGSizeMake(self.view.width - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
        
        _openTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.width - 30, height + 20)];
        _openTimeLabel.text = timeStr;
        _openTimeLabel.textColor = RGBACOLOR(65, 65, 65, 1);
        _openTimeLabel.font = [UIFont systemFontOfSize:17];
        _openTimeLabel.numberOfLines = 0;
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:timeStr];
        [attributeStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName:MainColor} range:NSMakeRange(0, 5)];
        _openTimeLabel.attributedText = attributeStr;
    }
    return _openTimeLabel;
}
// 电话
- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        NSString *phoneStr = [NSString stringWithFormat:@"电话：%@",self.placeModel.mobie];
        _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.width - 30, 50)];
        _phoneLabel.textColor = RGBACOLOR(65, 65, 65, 1);
        _phoneLabel.text = phoneStr;
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:phoneStr];
        [attributeStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName:MainColor} range:NSMakeRange(0, 3)];
        _phoneLabel.attributedText = attributeStr;
    }
    return _phoneLabel;
}
// 地址
- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        NSString *addressStr = [NSString stringWithFormat:@"地址：%@",self.placeModel.address];
        CGFloat height = [addressStr boundingRectWithSize:CGSizeMake(self.view.width - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
        
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.width - 30, height + 30)];
        _addressLabel.text = addressStr;
        _addressLabel.textColor = RGBACOLOR(65, 65, 65, 1);
        _addressLabel.font = [UIFont systemFontOfSize:17];
        _addressLabel.numberOfLines = 0;
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:addressStr];
        [attributeStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName:MainColor} range:NSMakeRange(0, 3)];
        _addressLabel.attributedText = attributeStr;
    }
    return _addressLabel;
}
// 门票
- (UILabel *)ticketLabel
{
    if (!_ticketLabel) {
        NSString *ticketStr = [NSString stringWithFormat:@"门票：%@",self.placeModel.ticket];
        CGFloat height = [ticketStr boundingRectWithSize:CGSizeMake(self.view.width - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
        
        _ticketLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.width - 30, height + 20)];
        _ticketLabel.text = ticketStr;
        _ticketLabel.textColor = RGBACOLOR(65, 65, 65, 1);
        _ticketLabel.font = [UIFont systemFontOfSize:17];
        _ticketLabel.numberOfLines = 0;
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:ticketStr];
        [attributeStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName:MainColor} range:NSMakeRange(0, 3)];
        _ticketLabel.attributedText = attributeStr;
        
    }
    return _ticketLabel;
}
// 高德地图
- (MAMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 250)];
        _mapView.delegate = self;
        _mapView.mapType = MAMapTypeSatellite;
    }
    return _mapView;
}

@end
