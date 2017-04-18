//
//  FoNewsViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/1/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "FoNewsViewController.h"
#import "NewsTableViewCell.h"
#import "DetialNewsViewController.h"
#import <MJRefresh.h>
#import <Masonry.h>


@interface FoNewsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *array;

@end

@implementation FoNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佛界头条";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 90;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    UIImageView *headImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"news_top_place"]];
    headImgView.frame = CGRectMake(0, 0, self.view.width, 80);
    self.tableView.tableHeaderView = headImgView;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsTableViewCell *cell = [NewsTableViewCell sharedNewsCell:tableView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetialNewsViewController *news = [DetialNewsViewController new];
    [self.navigationController pushViewController:news animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}




@end
