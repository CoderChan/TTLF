//
//  GoodsDetialController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/1/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "GoodsDetialController.h"
#import "NormalTableViewCell.h"
#import "UIButton+Category.h"
#import "TaobaoGoodsController.h"
#import "ServersViewController.h"
#import "GoodDetialFootView.h"
#import <SDCycleScrollView.h>
#import "XLPhotoBrowser.h"


@interface GoodsDetialController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 轮播图 */
@property (strong,nonatomic) SDCycleScrollView *scrollView;

@end

@implementation GoodsDetialController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"饰品详情";
    
    [self setupSubViews];
}

#pragma mark - 绘制表格
- (void)setupSubViews
{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
    
    // 添加表格
    self.array = @[@[@"封面轮播图"],@[@"商品名称",@"商品价格"],@[@"产品规格"]];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 50)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    // 左边：客服、淘宝。
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), self.view.width * 0.4, 50)];
    leftView.backgroundColor = RGBACOLOR(247, 247, 217, 1);
    [self.view addSubview:leftView];
    
    // 客服
    UIButton *serverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    serverBtn.frame = CGRectMake(0, 0, leftView.width/2, leftView.height);
    [serverBtn setTitle:@"客服" forState:UIControlStateNormal];
    [serverBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [serverBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        ServersViewController *server = [[ServersViewController alloc]init];
        [self.navigationController pushViewController:server animated:YES];
    }];
    serverBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [serverBtn setImage:[UIImage imageNamed:@"good_kefu"] forState:UIControlStateNormal];
    [serverBtn setImage:[UIImage imageNamed:@"good_kefu"] forState:UIControlStateHighlighted];
    [leftView addSubview:serverBtn];
    [serverBtn centerImageAndTitle:5];
    
    // 淘宝
    UIButton *taobaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    taobaoBtn.frame = CGRectMake(serverBtn.width, 0, leftView.width/2, leftView.height);
    [taobaoBtn setTitle:@"淘宝" forState:UIControlStateNormal];
    [taobaoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [taobaoBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
        TaobaoGoodsController *taobao = [[TaobaoGoodsController alloc]init];
        [self.navigationController pushViewController:taobao animated:YES];
        
    }];
    taobaoBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [taobaoBtn setImage:[UIImage imageNamed:@"good_taobao"] forState:UIControlStateNormal];
    [taobaoBtn setImage:[UIImage imageNamed:@"good_taobao"] forState:UIControlStateHighlighted];
    [leftView addSubview:taobaoBtn];
    [taobaoBtn centerImageAndTitle:2.5];
    
    // 加入购物车
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.backgroundColor = RGBACOLOR(63, 72, 123, 1);
    addButton.frame = CGRectMake(leftView.width, CGRectGetMaxY(self.tableView.frame), self.view.width * 0.3, 50);
    [addButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [addButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
    }];
    [self.view addSubview:addButton];
    
    // 立即购买
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    buyButton.backgroundColor = MainColor;
    buyButton.frame = CGRectMake(leftView.width + addButton.width, CGRectGetMaxY(self.tableView.frame), self.view.width * 0.3, 50);
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [buyButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
       
    }];
    [self.view addSubview:buyButton];
    
    
    // FootView
    GoodDetialFootView *footView = [[GoodDetialFootView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
    
    self.tableView.tableFooterView = footView;
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 产品轮播图
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell.iconView removeFromSuperview];
        [cell.titleLabel removeFromSuperview];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.contentView addSubview:self.scrollView];
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            // 商品名称
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            [cell.iconView removeFromSuperview];
            [cell.titleLabel removeFromSuperview];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"母亲节特惠，1.5厘米小叶紫檀";
            return cell;
        }else{
            // 商品价格
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [cell.iconView removeFromSuperview];
            [cell.titleLabel removeFromSuperview];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = WarningColor;
            cell.textLabel.text = @"￥600";
            return cell;
        }
    }else{
        // 产品规格
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return (self.view.height - 64 - 50)*0.75;
    } else {
        return 50;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}

#pragma mark - 其他方法
- (void)shareAction
{
    
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSArray *imageArray = cycleScrollView.imageURLStringsGroup;
    [XLPhotoBrowser showPhotoBrowserWithImages:imageArray currentImageIndex:index];
}

- (SDCycleScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.width, (self.view.height - 64 - 50)*0.75) delegate:self placeholderImage:[UIImage imageWithColor:RGBACOLOR(63, 72, 123, 1)]];
        _scrollView.imageURLStringsGroup = @[@"http://photocdn.sohu.com/20150716/mp23060992_1437043605508_5.png",@"http://photocdn.sohu.com/20150716/mp23060992_1437043605508_5.png",@"http://photocdn.sohu.com/20150716/mp23060992_1437043605508_5.png",@"http://photocdn.sohu.com/20150716/mp23060992_1437043605508_5.png"];
        
    }
    return _scrollView;
}

@end
