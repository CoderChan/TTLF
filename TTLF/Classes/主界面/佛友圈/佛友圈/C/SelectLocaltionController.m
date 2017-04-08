//
//  SelectLocaltionController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/2/28.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SelectLocaltionController.h"
#import "NormalTableViewCell.h"


@interface SelectLocaltionController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;

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
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell.iconView removeFromSuperview];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
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
