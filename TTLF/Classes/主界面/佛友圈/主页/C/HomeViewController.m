//
//  HomeViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/1/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "HomeViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "FYQImgTableViewCell.h"
#import "CommentViewController.h"
#import "NewsHeadView.h"
#import "FoNewsViewController.h"
#import "UserInfoViewController.h"
#import "PunnaNumViewController.h"
#import "FoNewsViewController.h"
#import "PhotosViewController.h"
#import "TopicsViewController.h"
#import "XLPhotoBrowser.h"
#import "LocationViewController.h"


@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,FYQTableCellDelegate>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 今日头条 */
@property (strong,nonatomic) NewsHeadView *headView;

@end



@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佛友圈";
    [self setupSubViews];
}

#pragma mark - 绘制表格
- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }];
    
    __weak HomeViewController *copySelf = self;
    self.headView = [[NewsHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 320)];
    self.headView.userModel = [[TTLFManager sharedManager].userManager getUserInfo];
    self.headView.ClickBlock = ^(ClickType type) {
        if (type == HeadUserClickType) {
            UserInfoViewController *userInfo = [UserInfoViewController new];
            [copySelf.navigationController pushViewController:userInfo animated:YES];
        }else if (type == HeadGongdeClickType){
            PunnaNumViewController *punna = [PunnaNumViewController new];
            [copySelf.navigationController pushViewController:punna animated:YES];
        }else if(type == HeadNewsClickType){
            FoNewsViewController *news = [FoNewsViewController new];
            [copySelf.navigationController pushViewController:news animated:YES];
        }
    };
    self.tableView.tableHeaderView = self.headView;
}


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
    FYQImgTableViewCell *cell = [FYQImgTableViewCell sharedFYQImgTableViewCell:tableView];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CommentViewController *comment = [CommentViewController new];
    [self.navigationController pushViewController:comment animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 380;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3;
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 108)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = self.view.backgroundColor;
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 恢复那条线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefaultPrompt];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"xian"]];
    
    self.headView.userModel = [[TTLFManager sharedManager].userManager getUserInfo];
}

#pragma mark - 其他方法
- (void)douleClickReloadAction
{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 其他代理
- (void)fyqTableCellClickType:(FYQCellClickType)clickType Model:(DynamicModel *)model
{
    
    if (clickType == UserClickType) {
        // 查看发帖人
        PhotosViewController *photos = [[PhotosViewController alloc]init];
        [self.navigationController pushViewController:photos animated:YES];
    }else if (clickType == TopicClickType){
        // 话题
        TopicsViewController *topic = [[TopicsViewController alloc]init];
        [self.navigationController pushViewController:topic animated:YES];
    }else if (clickType == PhotoClickType){
        // 查看大图
        UIImage *testImg = [UIImage imageNamed:@"user_place"];
        [XLPhotoBrowser showPhotoBrowserWithImages:@[testImg] currentImageIndex:0];
    }else if (clickType == LocationClickType){
        // 查看地理位置
        LocationModel *model = [LocationModel new];
        model.latitude = @"46.284681";
        model.longitude = @"114.158177";
        model.address = @"北京市海淀区中观村大街";
        LocationViewController *location = [[LocationViewController alloc]initWithLocation:model];
        [self.navigationController pushViewController:location animated:YES];
    }else if (clickType == ZanClickType){
        // 点赞
        [MBProgressHUD showSuccess:@"疯狂点赞"];
    }else if (clickType == DiscussClickType){
        // 评论
        CommentViewController *comment = [[CommentViewController alloc]init];
        [self.navigationController pushViewController:comment animated:YES];
    }else if (clickType == ShareClickType){
        [MBProgressHUD showError:@"分享到朋友圈"];
    }
}


@end
