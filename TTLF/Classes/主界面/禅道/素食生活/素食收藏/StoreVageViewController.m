//
//  StoreVageViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/23.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "StoreVageViewController.h"
#import "VageStoreTableViewCell.h"

@interface StoreVageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation StoreVageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"素食收藏";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 15 + 30 + 15 + 110 *CKproportion + 20;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"取消收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    action.backgroundColor = WarningColor;
    return @[action];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 15;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VageStoreTableViewCell *cell = [VageStoreTableViewCell sharedVageCell:tableView];
    
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
