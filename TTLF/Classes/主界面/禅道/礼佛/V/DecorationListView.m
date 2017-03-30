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
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 70, self.width, 70)];
    footView.backgroundColor = [UIColor clearColor];
    footView.userInteractionEnabled = YES;
    [self addSubview:footView];
    
    // 底部关闭按钮
    UIImageView *closeBtnBgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lifo_gongqing_btn"]];
    closeBtnBgView.frame = CGRectMake(footView.width/2 - 60, (70-45)/2, 120, 45);
    closeBtnBgView.userInteractionEnabled = YES;
    [footView addSubview:closeBtnBgView];
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self removeFromSuperview];
    }];
    closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [closeButton setTitle:@"关  闭" forState:UIControlStateNormal];
    closeButton.frame = closeBtnBgView.bounds;
    [closeBtnBgView addSubview:closeButton];
    
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
    
    if (self.decorationType == FlowerType) {
        FlowerVaseModel *model = self.array[indexPath.section];
        [[TTLFManager sharedManager].networkManager everydayLifoWithFlower:model Success:^{
            if ([self.delegate respondsToSelector:@selector(decorationListViewWithType:SelectModel:)]) {
                
                [_delegate decorationListViewWithType:self.decorationType SelectModel:model];
                [self removeFromSuperview];
                
            }
        } Fail:^(NSString *errorMsg) {
            [MBProgressHUD showError:errorMsg];
        }];
    }else if (self.decorationType == FruitType){
        FruitBowlModel *model = self.array[indexPath.section];
        [[TTLFManager sharedManager].networkManager everydayLifoWithFruit:model Success:^{
            if ([self.delegate respondsToSelector:@selector(decorationListViewWithType:SelectModel:)]) {
                
                [_delegate decorationListViewWithType:self.decorationType SelectModel:model];
                [self removeFromSuperview];
                
            }
        } Fail:^(NSString *errorMsg) {
            [MBProgressHUD showError:errorMsg];
        }];
    }else if (self.decorationType == XiangType){
        XiangModel *model = self.array[indexPath.section];
        [[TTLFManager sharedManager].networkManager everydayLifoWithXiang:model Success:^{
            if ([self.delegate respondsToSelector:@selector(decorationListViewWithType:SelectModel:)]) {
                
                [_delegate decorationListViewWithType:self.decorationType SelectModel:model];
                [self removeFromSuperview];
                
            }
        } Fail:^(NSString *errorMsg) {
            [MBProgressHUD showError:errorMsg];
        }];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.decorationType == XiangType) {
        return 120;
    }else if (self.decorationType == FlowerType){
        return 160;
    }else{
        return 130;
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height - 70) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}



@end
