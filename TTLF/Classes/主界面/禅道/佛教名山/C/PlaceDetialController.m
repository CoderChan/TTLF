//
//  PlaceDetialController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/26.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PlaceDetialController.h"
#import "NormalTableViewCell.h"
#import "RightMoreView.h"
#import "XLPhotoBrowser.h"
#import <MapKit/MapKit.h>
#import "ImageTableViewCell.h"
#import "PlacePicturesController.h"
#import "PlaceDiscussController.h"


@interface PlaceDetialController ()<UITableViewDelegate,UITableViewDataSource,RightMoreViewDelegate>
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;

/** 封面 */
@property (strong,nonatomic) UIImageView *coverImgView;
/** 查看点评 */
@property (strong,nonatomic) UILabel *commentLabel;
/** 旅行攻略 */
@property (strong,nonatomic) UILabel *travelLabel;
/** 开放时间 */
@property (strong,nonatomic) UILabel *openTimeLabel;
/** 地图 */
@property (strong,nonatomic) MKMapView *mapView;
/** 电话 */
@property (strong,nonatomic) UILabel *phoneLabel;
/** 地址 */
@property (strong,nonatomic) UILabel *locationLabel;
/** 门票 */
@property (strong,nonatomic) UILabel *ticketLabel;


@end

@implementation PlaceDetialController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"杭州灵隐寺";
    [self setupSubViews];
    
}

- (void)setupSubViews
{

    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(moreAction)];
    
    self.array = @[@[@"封面",@"查看点评"],@[@"旅行攻略",@"开放时间"],@[@"地图导航"],@[@"电话",@"地址",@"门票"]];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
}
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
            cell.image_url = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1494164277360&di=041789287b9496fac576b9589bc6213a&imgtype=0&src=http%3A%2F%2Fpic.92to.com%2F360%2F201604%2F11%2F2556131_201208031421560125.jpg";
            return cell;
        } else {
            // 查看点评
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.titleLabel removeFromSuperview];
            [cell.iconView removeFromSuperview];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            return cell;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            // 旅行攻略
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            [cell.titleLabel removeFromSuperview];
            [cell.iconView removeFromSuperview];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            return cell;
        } else {
            // 开放时间
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            [cell.titleLabel removeFromSuperview];
            [cell.iconView removeFromSuperview];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            return cell;
        }
    }else if (indexPath.section == 2){
        // 地图导航
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell.titleLabel removeFromSuperview];
        [cell.iconView removeFromSuperview];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = self.array[indexPath.section][indexPath.row];
        return cell;
    }else {
        if (indexPath.row == 0) {
            // 电话
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            [cell.titleLabel removeFromSuperview];
            [cell.iconView removeFromSuperview];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            return cell;
        }else if (indexPath.row == 1){
            // 地址
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            [cell.titleLabel removeFromSuperview];
            [cell.iconView removeFromSuperview];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            return cell;
        }else {
            // 门票
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            [cell.titleLabel removeFromSuperview];
            [cell.iconView removeFromSuperview];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
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
    } else {
        
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
            return 120;
        } else {
            // 开放时间
            return 55;
        }
    }else if (indexPath.section == 2){
        // 地图导航
        return 150;
    }else {
        if (indexPath.row == 0) {
            // 电话
            return 55;
        }else if (indexPath.row == 1){
            // 地址
            return 55;
        }else {
            // 门票
            return 55;
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


@end
