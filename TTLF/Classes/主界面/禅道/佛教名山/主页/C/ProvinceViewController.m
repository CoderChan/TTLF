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
@property (copy,nonatomic) NSArray *array;
/** 索引数据源 */
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
    
    self.array = @[@[@"北京市",@"上海市",@"天津市",@"重庆市"],@[@"港澳台"],@[@"海外地区"],@[@"广东省",@"浙江省",@"河北省",@"山东省",@"辽宁省",@"吉林省",@"黑龙江省",@"甘肃省",@"青海省",@"河南省",@"江苏省",@"湖南省",@"江西省",@"福建省",@"海南省",@"山西省",@"陕西省",@"四川省",@"安徽省",@"湖北省",@"云南省",@"贵州省"],@[@"广西壮族自治区",@"内蒙古自治区",@"西藏自治区",@"新疆维吾尔自治区",@"宁夏回族自治区"]];
    self.sectionArray = @[@"直",@"特",@"海",@"省",@"自"];
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
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *province = self.array[indexPath.section][indexPath.row];
    if (self.SelectProvinceBlock) {
        _SelectProvinceBlock(province);
        [self dismissAction];
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
