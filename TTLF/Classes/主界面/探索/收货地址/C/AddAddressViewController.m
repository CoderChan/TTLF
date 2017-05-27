//
//  AddAddressViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AddAddressViewController.h"
#import "NoDequeTableViewCell.h"
#import "CMPopTipView.h"

@interface AddAddressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>

/** 地址模型 */
@property (strong,nonatomic) AddressModel *addressModel;
/** 是否为新增地址 */
@property (assign,nonatomic) BOOL isAddNewAddress;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 收货人名字 */
@property (strong,nonatomic) UITextField *nameField;
/** 电话 */
@property (strong,nonatomic) UITextField *phoneField;
/** 详细地址 */
@property (strong,nonatomic) UITextView *addressView;

@end

@implementation AddAddressViewController

- (instancetype)initWithModel:(AddressModel *)addressModel
{
    self = [super init];
    if (self) {
        if (addressModel) {
            self.addressModel = addressModel;
            self.title = @"修改地址";
            self.isAddNewAddress = NO;
        }else{
            self.addressModel = nil;
            self.isAddNewAddress = YES;
            self.title = @"新增地址";
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        if (self.nameField.text.length == 0) {
            [self showPopTipsWithMessage:@"请输入联系人" AtView:self.nameField inView:self.view];
            return ;
        }
        if (![self.phoneField.text isPhoneNum]) {
            [self showPopTipsWithMessage:@"号码有误" AtView:self.phoneField inView:self.view];
            return ;
        }
        if (self.addressView.text.length == 0) {
            [self showPopTipsWithMessage:@"输入地址" AtView:self.addressView inView:self.view];
            return ;
        }
        if (self.isAddNewAddress) {
            // 新增地址
            [[TTLFManager sharedManager].networkManager addNewAddressWithModel:self.addressModel Success:^{
                if (self.DidFinishedBlock) {
                    _DidFinishedBlock();
                    [self.navigationController dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }
            } Fail:^(NSString *errorMsg) {
                [self sendAlertAction:errorMsg];
            }];
        }else{
            // 修改地址
            [[TTLFManager sharedManager].networkManager updateAddressWithModel:self.addressModel Success:^{
                [self showOneAlertWithMessage:@"修改成功" ConfirmClick:^{
                    if (self.DidFinishedBlock) {
                        _DidFinishedBlock();
                        [self.navigationController dismissViewControllerAnimated:YES completion:^{
                            
                        }];
                    }
                }];
            } Fail:^(NSString *errorMsg) {
                [self sendAlertAction:errorMsg];
            }];
        }
    }];
    [footView addSubview:button];
    
    self.tableView.tableFooterView = footView;
}
#pragma mark - 表格相关
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

#pragma mark - 赋值
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text containsString:@" "]) {
        [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    if (textField == self.nameField) {
        self.addressModel.name = textField.text;
    }else if (textField == self.phoneField){
        self.addressModel.phone = textField.text;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text containsString:@" "]) {
        [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    self.addressModel.address_detail = textView.text;
}

#pragma mark - 懒加载
- (UITextField *)nameField
{
    if (!_nameField) {
        _nameField = [[UITextField alloc]initWithFrame:CGRectMake(110, 5, self.view.width - 110 - 20, 40)];
        _nameField.delegate = self;
        _nameField.text = self.addressModel.name;
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
        _phoneField.delegate = self;
        _phoneField.text = self.addressModel.phone;
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
        _addressView.delegate = self;
        _addressView.text = self.addressModel.address_detail;
        _addressView.font = [UIFont systemFontOfSize:17];
        _addressView.backgroundColor = [UIColor whiteColor];
    }
    return _addressView;
}
- (AddressModel *)addressModel
{
    if (!_addressModel) {
        _addressModel = [[AddressModel alloc]init];
    }
    return _addressModel;
}

@end
