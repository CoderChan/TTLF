//
//  PunnaListViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/3/7.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PunnaListViewController.h"
#import "PunnaListTableCell.h"
#import <MJRefresh/MJRefresh.h>
#import "PunaListHeadView.h"
#import "YearMonthPickerView.h"


@interface PunnaListViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** xxxx年xx月 */
@property (copy,nonatomic) NSString *yearMonth;
/** 头部 */
@property (strong,nonatomic) PunaListHeadView *headView;

@end

@implementation PunnaListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"功德值记录";
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    NSString *dateStr = [NSString stringWithFormat:@"%@",[NSDate date]];
    self.yearMonth = [dateStr substringWithRange:NSMakeRange(0, 7)];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[TTLFManager sharedManager].networkManager getPunaNumWithMonth:self.yearMonth Success:^(NSArray *array) {
            
            self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                
            }];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView.mj_header endRefreshing];
            self.array = array;
            [self.tableView reloadData];
            
            
        } Fail:^(NSString *errorMsg) {
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD showError:errorMsg];
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PunnaListTableCell *cell = [PunnaListTableCell sharedPunnaListTableCell:tableView];
    cell.model = self.array[indexPath.row];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LogFuncName
    self.headView = [[PunaListHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    __weak __block PunnaListViewController *copySelf = self;
    self.headView.ClickBlock = ^(){
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        YearMonthPickerView *pickerView = [[YearMonthPickerView alloc]initWithFrame:keyWindow.bounds];
        pickerView.SelectMonthBlock = ^(NSString *year,NSString *month){
            NSString *yearMonth = [NSString stringWithFormat:@"%@-%@",year,month];
            copySelf.headView.yearMonth = yearMonth;
            copySelf.yearMonth = yearMonth;
            [copySelf.tableView.mj_header beginRefreshing];
            
        };
        [keyWindow addSubview:pickerView];
    };
    self.headView.yearMonth = self.yearMonth;
    self.headView.sumPunaNum = [self getSumPunaNum];
    
    return self.headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 70;
        _tableView.backgroundColor = self.view.backgroundColor;
    }
    return _tableView;
}

- (NSString *)getSumPunaNum
{
    double sumNum;
    for (int i = 0; i < self.array.count; i++) {
        PunaNumListModel *model = self.array[i];
        double value = [model.option_value doubleValue];
        sumNum += value;
    }
    
    NSString *sum = [NSString stringWithFormat:@"%.2f",sumNum];
    NSLog(@"sum = %@",sum);
    return sum;
}

@end
