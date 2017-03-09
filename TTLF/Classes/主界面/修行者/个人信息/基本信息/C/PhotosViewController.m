//
//  PhotosViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/2/26.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PhotosViewController.h"
#import "NormalTableViewCell.h"


@interface PhotosViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UIView *topBgView;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;



@end

#define topViewH 230*CKproportion

@implementation PhotosViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相册";
    [self setupSubViews];
}

- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
    [self.tableView insertSubview:self.topBgView atIndex:0];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"rightbar_message"] style:UIBarButtonItemStylePlain target:self action:@selector(messageAction)];
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    [cell.titleLabel removeFromSuperview];
    [cell.iconView removeFromSuperview];
    cell.backgroundColor = [UIColor whiteColor];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
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
#pragma mark - 方法动作
- (void)messageAction
{
    
}
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 100;
        _tableView.contentInset = UIEdgeInsetsMake(220*CKproportion, 0, 0, 0);
        _tableView.backgroundColor = self.view.backgroundColor;
    }
    return _tableView;
}
- (UIView *)topBgView
{
    if (!_topBgView) {
        _topBgView = [[UIView alloc]initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _topBgView.backgroundColor = RGBACOLOR(87, 87, 87, 1);
        _topBgView.userInteractionEnabled = YES;
    }
    return _topBgView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

@end
