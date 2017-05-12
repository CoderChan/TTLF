//
//  BookStoreViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/1.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "BookStoreViewController.h"
#import "BookStoreTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "BookDetialViewController.h"


@interface BookStoreViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 背景图片 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;

@end

@implementation BookStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"藏经阁";
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    self.array = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2", nil];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 120;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search_bar"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBookAction)];
//    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBookAction)];
    
}

- (void)searchBookAction
{
    
}

#pragma mark - CollectionView代理
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
    BookStoreTableViewCell *cell = [BookStoreTableViewCell sharedBookStoreCell:tableView];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BookDetialViewController *detial = [BookDetialViewController new];
    [self.navigationController pushViewController:detial animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [UIView new];
    foot.backgroundColor = [UIColor clearColor];
    return foot;
}


@end
