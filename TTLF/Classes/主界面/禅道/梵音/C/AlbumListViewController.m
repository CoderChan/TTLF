//
//  AlbumListViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/6/19.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AlbumListViewController.h"
#import "PlayingRightBarView.h"
#import "MusicPlayingController.h"
#import "NormalTableViewCell.h"
#import "AlbumHeadView.h"

@interface AlbumListViewController ()<UITableViewDelegate,UITableViewDataSource>
// 表格
@property (strong,nonatomic) UITableView *tableView;
// 数据源
@property (copy,nonatomic) NSArray *array;
// 头部
@property (strong,nonatomic) AlbumHeadView *headView;

@end

@implementation AlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专辑列表";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.view.backgroundColor = [UIColor grayColor];
    // 右侧播放器
    PlayingRightBarView *play = [[PlayingRightBarView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    play.ClickBlock = ^{
        MusicPlayingController *musicPlaying = [[MusicPlayingController alloc]init];
        [self.navigationController pushViewController:musicPlaying animated:YES];
    };
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:play];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // 表格
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    // 头部
    self.headView = [[AlbumHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
    
    self.tableView.tableHeaderView = self.headView;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.array.count;
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}


@end
