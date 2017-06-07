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
#import <MJRefresh.h>


@interface GoodClassListController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 分类数据源 */
@property (copy,nonatomic) NSArray *array;
/** 头部 */
@property (strong,nonatomic) GoodClassHeadView *headView;
/** 分类模型 */
@property (strong,nonatomic) GoodsClassModel *goodsCateModel;


@end


@implementation GoodClassListController

- (instancetype)initWithModel:(GoodsClassModel *)model
{
    self = [super init];
    if (self) {
        self.goodsCateModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.goodsCateModel.cate_name;
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
    
    self.headView = [[GoodClassHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 280*CKproportion)];
    
    self.headView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headView;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[TTLFManager sharedManager].networkManager goodsListWithCateModel:self.goodsCateModel Success:^(NSArray *array) {
            self.tableView.hidden = NO;
            [self hidesBottomBarWhenPushed];
            [self.tableView.mj_header endRefreshing];
            self.array = array;
            for (int i = 0; i < array.count; i++) {
                GoodsInfoModel *model = array[i];
                self.headView.model = model;
            }
            [self.tableView reloadData];
            
        } Fail:^(NSString *errorMsg) {
            self.tableView.hidden = YES;
            [self showEmptyViewWithMessage:errorMsg];
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
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
    GoodsInfoModel *goodsInfo = self.array[indexPath.row];
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    cell.titleLabel.text = goodsInfo.article_name;
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:goodsInfo.article_logo] placeholderImage:[UIImage imageNamed:@"goods_place"]];
    [cell.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left).offset(15);
        make.centerY.equalTo(cell.mas_centerY);
        make.width.and.height.equalTo(@60);
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
