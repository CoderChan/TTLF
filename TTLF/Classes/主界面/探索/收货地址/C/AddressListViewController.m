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

@interface AddressListViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 地址数据源 */
@property (copy,nonatomic) NSArray *array;

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
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setTitle:@"新增收货地址" forState:UIControlStateNormal];
    addButton.backgroundColor = MainColor;
    addButton.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), self.view.width, 50);
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [addButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        AddAddressViewController *add = [[AddAddressViewController alloc]init];
        RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:add];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }];
    [self.view addSubview:addButton];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    return self.array.count;
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressTableViewCell *cell = [AddressTableViewCell sharedAddressCell:tableView];
    
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
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    action1.backgroundColor = MainColor;
    
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    action2.backgroundColor = RGBACOLOR(63, 72, 123, 1);
    
    return @[action1,action2];
}



@end
