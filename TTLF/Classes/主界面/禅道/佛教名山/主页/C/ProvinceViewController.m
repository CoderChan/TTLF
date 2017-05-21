//
//  ProvinceViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/25.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "ProvinceViewController.h"
#import "NormalTableViewCell.h"
#import <MJRefresh/MJRefresh.h>


@interface ProvinceViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) AreaListModel *areaListModel;
/** 索引 */
@property (copy,nonatomic) NSArray *sectionArray;


@end

@implementation ProvinceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择省市";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"dismiss"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.sectionArray = @[@"直",@"港",@"海",@"省",@"自"];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
    }];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    
    
    self.tableView.sectionIndexColor = MainColor;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    // 获取数据
    [[TTLFManager sharedManager].networkManager areaListSuccess:^(AreaListModel *areaListModel) {
        [self hideMessageAction];
        self.tableView.hidden = NO;
        self.areaListModel = areaListModel;
        [self.tableView reloadData];
    } Fail:^(NSString *errorMsg) {
        self.tableView.hidden = YES;
        [self showEmptyViewWithMessage:errorMsg];
    }];
    
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        // 直辖市
        return self.areaListModel.zhixiashi.count;
    }else if (section == 1){
        // 港澳台
        return self.areaListModel.gangaotai.count;
    }else if (section == 2){
        // 海外地区
        return self.areaListModel.haiwai.count;
    }else if (section == 3){
        // 地区省
        return self.areaListModel.sheng.count;
    }else{
        // 自治区
        return self.areaListModel.zizhiqu.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 直辖市
        AreaDetialModel *model = self.areaListModel.zhixiashi[indexPath.row];
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:model.province_img] placeholderImage:[UIImage imageWithColor:HWRandomColor]];
        cell.titleLabel.text = model.province_name;
        return cell;
    }else if (indexPath.section == 1){
        // 港澳台
        AreaDetialModel *model = self.areaListModel.gangaotai[indexPath.row];
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:model.province_img] placeholderImage:[UIImage imageWithColor:HWRandomColor]];
        cell.titleLabel.text = model.province_name;
        return cell;
    }else if (indexPath.section == 2){
        // 海外地区
        AreaDetialModel *model = self.areaListModel.haiwai[indexPath.row];
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:model.province_img] placeholderImage:[UIImage imageWithColor:HWRandomColor]];
        cell.titleLabel.text = model.province_name;
        return cell;
    }else if (indexPath.section == 3){
        // 省
        AreaDetialModel *model = self.areaListModel.sheng[indexPath.row];
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:model.province_img] placeholderImage:[UIImage imageWithColor:HWRandomColor]];
        cell.titleLabel.text = model.province_name;
        return cell;
    }else {
        // 自治区
        AreaDetialModel *model = self.areaListModel.zizhiqu[indexPath.row];
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:model.province_img] placeholderImage:[UIImage imageWithColor:HWRandomColor]];
        cell.titleLabel.text = model.province_name;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AreaDetialModel *model;
    if (indexPath.section == 0) {
        model = self.areaListModel.zhixiashi[indexPath.row];
    }else if (indexPath.section == 1){
        model = self.areaListModel.gangaotai[indexPath.row];
    }else if (indexPath.section == 2){
        model = self.areaListModel.haiwai[indexPath.row];
    }else if (indexPath.section == 3){
        model = self.areaListModel.sheng[indexPath.row];
    }else{
        model = self.areaListModel.zizhiqu[indexPath.row];
    }
    if (self.SelectProvinceBlock) {
        _SelectProvinceBlock(model);
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionArray;
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSLog(@"title = %@,index = %ld",title,(long)index);
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

#pragma mark - 其他方法
- (void)dismissAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
