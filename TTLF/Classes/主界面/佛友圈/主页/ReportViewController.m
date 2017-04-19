//
//  ReportViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/1.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "ReportViewController.h"
#import "NormalTableViewCell.h"
#import "ReportDetialViewController.h"

@interface ReportViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (copy,nonatomic) NSArray *array;

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"举报";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.array = @[@"谬论",@"误人子弟",@"色情",@"政治敏感",@"不实信息",@"造谣",@"骚扰",@"其他"];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
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
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    [cell.iconView removeFromSuperview];
    [cell.titleLabel removeFromSuperview];
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ReportDetialViewController *report = [ReportDetialViewController new];
    [self.navigationController pushViewController:report animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    headView.backgroundColor = RGBACOLOR(247,247, 247, 1);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 5, 120, 35)];
    label.text = @"请选择举报原因";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor grayColor];
    [headView addSubview:label];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}


@end
