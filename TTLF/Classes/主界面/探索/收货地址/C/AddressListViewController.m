//
//  AddressListViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddAddressViewController.h"
#import "AddressTableViewCell.h"
#import "RootNavgationController.h"
#import <MJRefresh.h>

@interface AddressListViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 地址数据源 */
@property (strong,nonatomic) NSMutableArray *array;

@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"管理收货地址";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 50)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 130;
    self.tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    // 新增地址按钮
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setTitle:@"新增收货地址" forState:UIControlStateNormal];
    addButton.backgroundColor = MainColor;
    addButton.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), self.view.width, 50);
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [addButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        AddAddressViewController *add = [[AddAddressViewController alloc]initWithModel:nil];
        add.DidFinishedBlock = ^{
            // 重新加载数据
            self.tableView.hidden = YES;
            [self hideMessageAction];
            [self getData];
        };
        RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:add];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }];
    [self.view addSubview:addButton];
    
    
}
- (void)getData
{
    [[TTLFManager sharedManager].networkManager getAddressListSuccess:^(NSArray *array) {
        [self.tableView.mj_header endRefreshing];
        self.tableView.hidden = NO;
        [self hideMessageAction];
        self.array = [NSMutableArray arrayWithArray:array];
        [self.tableView reloadData];
        
    } Fail:^(NSString *errorMsg) {
        [self.tableView.mj_header endRefreshing];
        self.tableView.hidden = YES;
        [self showEmptyViewWithMessage:errorMsg];
    }];
}
#pragma mark - 表格相关
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
    AddressModel *addressModel = self.array[indexPath.section];
    AddressTableViewCell *cell = [AddressTableViewCell sharedAddressCell:tableView];
    cell.model = addressModel;
    cell.SetDefaultBlock = ^(AddressModel *model) {
        [[TTLFManager sharedManager].networkManager setDefaultAddress:model Success:^{
            for (AddressModel *models in self.array) {
                models.is_default = NO;
            }
            model.is_default = YES;
            [self.array replaceObjectAtIndex:indexPath.section withObject:model];
            [self.tableView reloadData];
        } Fail:^(NSString *errorMsg) {
            [self sendAlertAction:errorMsg];
        }];
    };
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressModel *addressModel = self.array[indexPath.section];
    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[TTLFManager sharedManager].networkManager deleteAddressWithModel:addressModel Success:^{
            [self.array removeObjectAtIndex:indexPath.section];
            [self.tableView reloadData];
        } Fail:^(NSString *errorMsg) {
            [self sendAlertAction:errorMsg];
        }];
    }];
    action1.backgroundColor = MainColor;
    
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        AddAddressViewController *add = [[AddAddressViewController alloc]initWithModel:addressModel];
        add.DidFinishedBlock = ^{
          // 重新加载数据
            self.tableView.hidden = YES;
            [self hideMessageAction];
            [self getData];
        };
        RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:add];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }];
    action2.backgroundColor = RGBACOLOR(63, 72, 123, 1);
    
    return @[action1,action2];
}


- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

@end
