//
//  AddAddressViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AddAddressViewController.h"
#import "NoDequeTableViewCell.h"

@interface AddAddressViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;

@property (strong,nonatomic) UITextField *nameField;
@property (strong,nonatomic) UITextField *phoneField;
@property (strong,nonatomic) UITextView *addressView;

@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加收货地址";
    [self setupSubViews];
}
#pragma mark - 绘制界面
- (void)setupSubViews
{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissAction)];
    
    
    self.array = @[@"联系人",@"手机号码",@"详细地址"];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    // 保存按钮
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
    footView.userInteractionEnabled = YES;
    footView.backgroundColor = self.view.backgroundColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self.view endEditing:YES];
    }];
    [footView addGestureRecognizer:tap];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"保  存" forState:UIControlStateNormal];
    button.frame = CGRectMake(20, 40, footView.width - 40, 44);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    button.backgroundColor = MainColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.view endEditing:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [footView addSubview:button];
    
    self.tableView.tableFooterView = footView;
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
    if (indexPath.row == 0) {
        // 收货人姓名
        NoDequeTableViewCell *cell = [NoDequeTableViewCell sharedCell:tableView];
        cell.textLabel.text = self.array[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:self.nameField];
        return cell;
    }else if (indexPath.row == 1){
        // 手机号码
        NoDequeTableViewCell *cell = [NoDequeTableViewCell sharedCell:tableView];
        cell.textLabel.text = self.array[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:self.phoneField];
        return cell;
    }else {
        // 详细地址
        NoDequeTableViewCell *cell = [NoDequeTableViewCell sharedCell:tableView];
        cell.textLabel.text = self.array[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:self.addressView];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 50;
    }else if (indexPath.row == 1){
        return 50;
    }else{
        return 65;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}



#pragma mark - 其他方法
- (void)dismissAction
{
    [self.view endEditing:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - 懒加载
- (UITextField *)nameField
{
    if (!_nameField) {
        _nameField = [[UITextField alloc]initWithFrame:CGRectMake(110, 5, self.view.width - 110 - 20, 40)];
        _nameField.placeholder = @"收货人姓名";
        _nameField.backgroundColor = [UIColor whiteColor];
        _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _nameField;
}
- (UITextField *)phoneField
{
    if (!_phoneField) {
        _phoneField = [[UITextField alloc]initWithFrame:CGRectMake(110, 5, self.view.width - 110 - 20, 40)];
        _phoneField.placeholder = @"11位手机号";
        _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneField.backgroundColor = [UIColor whiteColor];
    }
    return _phoneField;
}
- (UITextView *)addressView
{
    if (!_addressView) {
        _addressView = [[UITextView alloc]initWithFrame:CGRectMake(110, 7.5, self.view.width - 110 - 20, 50)];
        _addressView.font = [UIFont systemFontOfSize:17];
        _addressView.backgroundColor = [UIColor whiteColor];
    }
    return _addressView;
}


@end
