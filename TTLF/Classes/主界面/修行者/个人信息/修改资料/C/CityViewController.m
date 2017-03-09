//
//  CityViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/1/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "CityViewController.h"
#import "ProvinceCityModel.h"
#import <MJExtension.h>
#import "NormalTableViewCell.h"


@interface CityViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 省份数据 */
@property (copy,nonatomic) NSArray *proArray;
/** 身份表格 */
@property (strong,nonatomic) UITableView *proTableView;

/** 城市数据 */
@property (copy,nonatomic) NSArray *cityArray;
/** 城市表格 */
@property (strong,nonatomic) UITableView *cityTableView;

@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所在地";
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    self.proArray =[ProvinceCityModel mj_objectArrayWithFilename:@"ProvincesAndCities.plist"];
    [self.view addSubview:self.proTableView];
    
    [self.view addSubview:self.cityTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.proTableView) {
        return self.proArray.count;
    }else{
        return self.cityArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.proTableView) {
        ProvinceCityModel *model = self.proArray[indexPath.row];
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell.iconView removeFromSuperview];
        cell.textLabel.text = model.State;
        return cell;
    }else{
        CityInfoModel *model = self.cityArray[indexPath.row];
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        [cell.iconView removeFromSuperview];
        cell.textLabel.text = model.city;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.proTableView) {
        // 先取数据，再刷新
        ProvinceCityModel *model = self.proArray[indexPath.row];
        self.cityArray = model.Cities;
        [self.cityTableView reloadData];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        CityInfoModel *cityModel = self.cityArray[indexPath.row];
        [[TTLFManager sharedManager].networkManager updateCity:cityModel.city Success:^{
            [self.navigationController popViewControllerAnimated:YES];
        } Fail:^(NSString *errorMsg) {
            [self sendAlertAction:errorMsg];
        }];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}
- (UITableView *)proTableView
{
    if (!_proTableView) {
        _proTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width * 0.4, self.view.height - 64)];
        _proTableView.dataSource = self;
        _proTableView.delegate = self;
        _proTableView.rowHeight = 44;
        _proTableView.backgroundColor = self.view.backgroundColor;
        _proTableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    }
    return _proTableView;
}
- (UITableView *)cityTableView
{
    if (!_cityTableView) {
        _cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.width * 0.4, 0, self.view.width * 0.6, self.view.height - 64)];
        _cityTableView.delegate = self;
        _cityTableView.dataSource = self;
        _cityTableView.rowHeight = 44;
        _cityTableView.backgroundColor = self.view.backgroundColor;
        _cityTableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    }
    return _cityTableView;
}

@end
