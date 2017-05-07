//
//  MyVagesViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/23.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MyVagesViewController.h"
#import "MyVageTableViewCell.h"


@interface MyVagesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *array;

@end

@implementation MyVagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我发布的素食";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    action.backgroundColor = WarningColor;
    return @[action];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyVageTableViewCell *cell = [MyVageTableViewCell shardMyVageCell:tableView];
    
    return cell;
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




@end
