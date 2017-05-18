//
//  GoodClassListController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "GoodClassListController.h"
#import "NormalTableViewCell.h"
#import <Masonry.h>
#import "GoodClassHeadView.h"
#import "GoodsDetialController.h"


@interface GoodClassListController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 分类数据源 */
@property (copy,nonatomic) NSArray *array;
/** 头部 */
@property (strong,nonatomic) GoodClassHeadView *headView;

@end

@implementation GoodClassListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"紫檀系列";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 64;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.headView = [[GoodClassHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 250*CKproportion)];
    self.headView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    cell.titleLabel.text = @"1.8厘米小叶紫檀";
    [cell.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left).offset(15);
        make.centerY.equalTo(cell.mas_centerY);
        make.width.and.height.equalTo(@40);
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsDetialController *detial = [GoodsDetialController new];
    [self.navigationController pushViewController:detial animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}





@end
