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


@interface PlaceDetialController ()<UITableViewDelegate,UITableViewDataSource,RightMoreViewDelegate>

@property (copy,nonatomic) NSArray *array;

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation PlaceDetialController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"杭州灵隐寺";
    [self setupSubViews];
    
}

- (void)setupSubViews
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"rightbar_more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.array = @[@[@"封面",@"旅行攻略",@"开放时间"],@[@"地图导航"],@[@"电话",@"地址",@"门票"]];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
}
- (void)moreAction
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    RightMoreView *moreView = [[RightMoreView alloc]initWithFrame:keyWindow.bounds];
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
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
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


@end
