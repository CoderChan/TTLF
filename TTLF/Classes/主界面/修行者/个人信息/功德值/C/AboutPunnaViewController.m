//
//  AboutPunnaViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/3/7.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AboutPunnaViewController.h"
#import "NormalTableViewCell.h"
#import <Masonry.h>

@interface AboutPunnaViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *array;

@end

@implementation AboutPunnaViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于功德值";
    [self setupSubViews];
}

- (void)setupSubViews
{
    // 佛界头条发布评论+0.1，每日最多3次。发布的素食被收藏+0.1。弘扬+1，每日最多2次。天天礼佛+1
    self.view.backgroundColor = [UIColor whiteColor];
    self.array = @[@"佛界头条发布评论，与佛友互动，+0.1功德值，每日最多加3次。",@"天天礼佛，每日+1功德值。",@"发布精品素食，每被收藏一次+0.1功德值，不上限。",@"弘扬佛缘生活，分享九宫格到社交网络，+1功德值，每日最多2次。"];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 120;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    [self.view addSubview:self.tableView];
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
    NSArray *iconArray = @[@"puna_discuss",@"puna_lifo_icon",@"puna_vege_store",@"wo_tuiguang"];
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.iconView.image = [UIImage imageNamed:iconArray[indexPath.row]];
    cell.titleLabel.text = self.array[indexPath.row];
    [cell.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left).offset(15);
        make.centerY.equalTo(cell.mas_centerY);
        make.width.and.height.equalTo(@40);
    }];
    cell.titleLabel.numberOfLines = 3;
    [cell.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.iconView.mas_centerY);
        make.left.equalTo(cell.iconView.mas_right).offset(12);
        make.right.equalTo(cell.contentView.mas_right).offset(-25);
        make.height.equalTo(@60);
    }];
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
    UIView *footView = [UIView new];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectZero];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}


@end
