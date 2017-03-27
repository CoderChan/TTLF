//
//  DecorationListView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/23.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "DecorationListView.h"
#import "DecorationTableCell.h"

@interface DecorationListView ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;

@end

@implementation DecorationListView

#pragma mark - 初始化
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = RGBACOLOR(0, 0, 0, 0.45);
    [self addSubview:self.tableView];
    
    // 底部视图
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, self.size.height - 80, self.size.width, 80)];
    footView.backgroundColor = HWRandomColor;
    footView.userInteractionEnabled = YES;
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self removeFromSuperview];
    }];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(100, (80 - 44)/2, footView.width - 200, 44);
    [footView addSubview:closeButton];
    self.tableView.tableFooterView = footView;
}

#pragma mark - 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DecorationTableCell *cell = [DecorationTableCell sharedDecorationCell:tableView];
    if (self.decorationType == FlowerType) {
        FlowerVaseModel *model = self.array[indexPath.section];
        cell.flowerModel = model;
    }else if (self.decorationType == XiangType){
        XiangModel *model = self.array[indexPath.section];
        cell.xiangModel = model;
    }else if (self.decorationType == FruitType){
        FruitBowlModel *model = self.array[indexPath.section];
        cell.fruitModel = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(decorationListViewWithType:SelectModel:)]) {
        
        [_delegate decorationListViewWithType:self.decorationType SelectModel:self.array[indexPath.section]];
        [self removeFromSuperview];
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.decorationType == XiangType) {
        return 120;
    }else{
        return 160;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [UIView new];
    foot.backgroundColor = [UIColor clearColor];
    return foot;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - 其他方法
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

@end
