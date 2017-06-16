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

#import <MapKit/MapKit.h>
#import "ImageTableViewCell.h"
#import "BigMapViewController.h"
#import "PlacePicturesController.h"
#import "PlaceDiscussController.h"
#import <MAMapKit/MAMapKit.h>
#import <MAMapKit/MAAnnotation.h>
#import <AMapSearchKit/AMapSearchKit.h>


@interface PlaceDetialController ()<UITableViewDelegate,UITableViewDataSource,RightMoreViewDelegate,MAMapViewDelegate,AMapSearchDelegate>
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
@property (strong,nonatomic) AMapSearchAPI *search;
/** 电话 */
@property (strong,nonatomic) UILabel *phoneLabel;
/** 地址 */
@property (strong,nonatomic) UILabel *addressLabel;
/** 门票 */
@property (strong,nonatomic) UILabel *ticketLabel;
/** 交通攻略 */
@property (strong,nonatomic) UILabel *trafficLabel;


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
    self.title = self.placeModel.scenic_name;
    [self setupSubViews];
    
}

- (void)setupSubViews
{

    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(moreAction)];
    
    self.array = @[@[@"封面",@"精彩游记见闻"],@[@"旅行攻略",@"开放时间"],@[@"电话：",@"地址：",@"门票："],@[@"交通攻略"]];
    
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
    NSString *shareURL = [NSString stringWithFormat:@"%@&userID=%@",self.placeModel.web_url,[AccountTool account].userID.base64EncodedString];
    if (clickType == WechatFriendType) {
        NSData *imageData = UIImageJPEGRepresentation(self.coverImgView.image, 0.01);
        NSInteger len = imageData.length / 1024;
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = self.placeModel.scenic_name;
        message.description = self.placeModel.strategy;
        if (len > 32) {
            [message setThumbImage:[UIImage imageNamed:@"app_logo"]];
        }else{
            [message setThumbData:imageData];
        }
        
        
        WXWebpageObject *webObject = [WXWebpageObject object];
        webObject.webpageUrl = shareURL;
        message.mediaObject = webObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = 0;
        [WXApi sendReq:req];
    }else if(clickType == WechatQuanType){
        NSData *imageData = UIImageJPEGRepresentation(self.coverImgView.image, 0.01);
        NSInteger len = imageData.length / 1024;
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = self.placeModel.scenic_name;
        message.description = self.placeModel.strategy;
        if (len > 32) {
            [message setThumbImage:[UIImage imageNamed:@"app_logo"]];
        }else{
            [message setThumbData:imageData];
        }
        
        
        WXWebpageObject *webObject = [WXWebpageObject object];
        webObject.webpageUrl = shareURL;
        message.mediaObject = webObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = 1;
        [WXApi sendReq:req];
    }else if (clickType == StoreClickType){
        
    }else if (clickType == QQFriendType){
        NSString *shareUrl = shareURL;
        NSString *title = self.placeModel.scenic_name;
        NSString *description = self.placeModel.strategy;
        NSString *previewImageUrl = self.placeModel.scenic_img;
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareUrl] title:title description:description previewImageURL:[NSURL URLWithString:previewImageUrl]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        //将内容分享到qq
        QQApiSendResultCode qqFriend = [QQApiInterface sendReq:req];
        [self sendToQQWithSendResult:qqFriend];
    }else if (clickType == QQSpaceType){
        NSString *shareUrl = shareURL;
        NSString *title = self.placeModel.scenic_name;
        NSString *description = self.placeModel.strategy;
        NSString *previewImageUrl = self.placeModel.scenic_img;
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareUrl] title:title description:description previewImageURL:[NSURL URLWithString:previewImageUrl]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        //将内容分享到qzone
        QQApiSendResultCode qqZone = [QQApiInterface SendReqToQZone:req];
        [self sendToQQWithSendResult:qqZone];
    }else if (clickType == OpenAtSafariType){
        // Safari打开
        NSURL *url = [NSURL URLWithString:shareURL];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            
        }];
    }else if (clickType == SystermShareType){
        // 系统分享
        NSURL *url = [NSURL URLWithString:shareURL];
        UIActivityViewController *activity = [[UIActivityViewController alloc]initWithActivityItems:@[self.coverImgView.image,self.placeModel.scenic_name,url] applicationActivities:nil];
        [self presentViewController:activity animated:YES completion:^{
            
        }];
    }else if (clickType == CopyUrlType){
        // 复制链接
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = shareURL;
        [MBProgressHUD showSuccess:@"已复制到剪切板"];
    }else if (clickType == RefreshType){
        // 重新加载网页
        
    }else if (clickType == StopLoadType){
        // 停止加载
    }
}
#pragma mark - 地图相关
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    BigMapViewController *mapVC = [[BigMapViewController alloc]initWithModel:self.placeModel];
    [self.navigationController pushViewController:mapVC animated:YES];
}
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    BigMapViewController *mapVC = [[BigMapViewController alloc]initWithModel:self.placeModel];
    [self.navigationController pushViewController:mapVC animated:YES];
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    return 0;
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    NSArray<AMapPOI *> *pois = response.pois;
    AMapPOI *lastPoi = [pois firstObject];
    AMapGeoPoint *point = lastPoi.location;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude);
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    
    NSMutableArray *annotationArray = [NSMutableArray array];
    for (int i = 0; i < pois.count; i++) {
        AMapPOI *mapPOI = pois[i];
        CLLocationCoordinate2D pointCoordinate = CLLocationCoordinate2DMake(mapPOI.location.latitude, mapPOI.location.longitude);
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc]init];
        
        pointAnnotation.coordinate = pointCoordinate;
        pointAnnotation.lockedToScreen = NO;
        [annotationArray addObject:pointAnnotation];
    }
    [self.mapView addAnnotations:annotationArray];
    
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
            NoDequeTableViewCell *cell = [NoDequeTableViewCell sharedCell:tableView];
            [cell.contentView addSubview:self.coverImgView];
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
    }else if(indexPath.section == 2){
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
        
    }else{
        // 交通攻略
        NoDequeTableViewCell *cell = [NoDequeTableViewCell sharedCell:tableView];
        [cell.contentView addSubview:self.trafficLabel];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 预览图集
            PlacePicturesController *picture = [[PlacePicturesController alloc]initWithModel:self.placeModel];
            [self.navigationController pushViewController:picture animated:YES];
        }else{
            // 评论界面
            PlaceDiscussController *discuss = [[PlaceDiscussController alloc]initWithModel:self.placeModel];
            [self.navigationController pushViewController:discuss animated:YES];
        }
    }else if (indexPath.section == 1){
        
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            // 电话
            UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectZero];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.placeModel.scenic_phone]];
            [webView loadRequest:[NSURLRequest requestWithURL:url]];
            [self.view addSubview:webView];
        }
    }else{
        // 交通
        BigMapViewController *map = [[BigMapViewController alloc]initWithModel:self.placeModel];
        [self.navigationController pushViewController:map animated:YES];
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
            NSString *travelStr = [NSString stringWithFormat:@"旅行攻略：%@",self.placeModel.strategy];
            CGFloat height = [travelStr boundingRectWithSize:CGSizeMake(self.view.width - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height + 20;
            return height;
        } else {
            // 开放时间
            NSString *timeStr = [NSString stringWithFormat:@"开放时间：%@",self.placeModel.open_time];
            CGFloat height = [timeStr boundingRectWithSize:CGSizeMake(self.view.width - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height + 20;
            return height;
        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            // 电话
            return 50;
        }else if (indexPath.row == 1){
            // 地址
            NSString *addressStr = [NSString stringWithFormat:@"地址：%@",self.placeModel.scenic_address];
            CGFloat height = [addressStr boundingRectWithSize:CGSizeMake(self.view.width - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height + 30;
            return height;
        }else {
            // 门票
            NSString *ticketStr = [NSString stringWithFormat:@"门票：%@",self.placeModel.scenic_ticket];
            CGFloat height = [ticketStr boundingRectWithSize:CGSizeMake(self.view.width - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
            return height + 20;
        }
    }else{
        // 交通攻略
        NSString *ticketStr = [NSString stringWithFormat:@"交通攻略：%@",self.placeModel.traic];
        CGFloat height = [ticketStr boundingRectWithSize:CGSizeMake(self.view.width - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
        return height + 20;
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
        _coverImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 220*CKproportion)];
        [_coverImgView sd_setImageWithURL:[NSURL URLWithString:self.placeModel.scenic_img] placeholderImage:[UIImage imageWithColor:MainColor]];
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
        NSString *travelStr = [NSString stringWithFormat:@"旅行攻略：%@",self.placeModel.strategy];
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
        NSString *phoneStr = [NSString stringWithFormat:@"电话：%@",self.placeModel.scenic_phone];
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
        NSString *addressStr = [NSString stringWithFormat:@"地址：%@",self.placeModel.scenic_address];
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
        NSString *ticketStr = [NSString stringWithFormat:@"门票：%@",self.placeModel.scenic_ticket];
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
        _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 250*CKproportion)];
        _mapView.delegate = self;
        _mapView.mapType = MAMapTypeSatellite;
        AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc]init];
        request.keywords = self.placeModel.scenic_name;
        request.requireExtension = YES;
        request.cityLimit = NO;
        request.requireSubPOIs = YES;
        [self.search AMapPOIKeywordsSearch:request];
    }
    return _mapView;
}
- (AMapSearchAPI *)search
{
    if (!_search) {
        _search = [[AMapSearchAPI alloc]init];
        _search.delegate = self;
    }
    return _search;
}
// 交通攻略
- (UILabel *)trafficLabel
{
    if (!_trafficLabel) {
        NSString *ticketStr = [NSString stringWithFormat:@"交通攻略：%@",self.placeModel.traic];
        CGFloat height = [ticketStr boundingRectWithSize:CGSizeMake(self.view.width - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
        
        _trafficLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.width - 30, height + 20)];
        _trafficLabel.text = ticketStr;
        _trafficLabel.textColor = RGBACOLOR(65, 65, 65, 1);
        _trafficLabel.font = [UIFont systemFontOfSize:17];
        _trafficLabel.numberOfLines = 0;
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:ticketStr];
        [attributeStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName:MainColor} range:NSMakeRange(0, 5)];
        _trafficLabel.attributedText = attributeStr;
    }
    return _trafficLabel;
}

@end
