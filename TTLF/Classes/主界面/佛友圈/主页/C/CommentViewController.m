//
//  CommentViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/30.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "CommentViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJProperty.h>
#import "NormalTableViewCell.h"
#import "CommentHeadView.h"
#import "CommentFootView.h"

@interface CommentViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 评论数据源 */
@property (strong,nonatomic) NSMutableArray *array;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看详情";
    [self setupSubViews];
}

- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
    
    // 原贴作为HeadView
    CommentHeadView *headView = [[CommentHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 160)];
    self.tableView.tableHeaderView = headView;
    
    // 底部评论视图
    CommentFootView *footView = [[CommentFootView alloc]initWithFrame:CGRectMake(0, self.view.height - 50 - 64, self.view.width, 50)];
    [self.view addSubview:footView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.array.count;
    return 12;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    [cell.iconView removeFromSuperview];
    [cell.titleLabel removeFromSuperview];
    cell.backgroundColor = self.view.backgroundColor;
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
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 50)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 90;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    }
    return _tableView;
}


@end
