//
//  ReportDetialViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/1.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "ReportDetialViewController.h"
#import "NormalTableViewCell.h"


#define PlaceText @"请输入举报内容"
@interface ReportDetialViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *array;

@property (strong,nonatomic) UITextView *textView;

@end

@implementation ReportDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"举报描述";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.array = @[@"举报原因补充（非必填）"];
    
//    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 150*CKproportion;
    self.tableView.backgroundColor = self.view.backgroundColor;
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
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = self.view.backgroundColor;
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell.iconView removeFromSuperview];
    [cell.titleLabel removeFromSuperview];
    [cell.contentView addSubview:self.textView];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, self.view.width, 40)];
    headView.backgroundColor = self.view.backgroundColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, self.view.width, 35)];
    label.text = self.array[section];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor blackColor];
    [headView addSubview:label];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.view.height - 64 - 40 - 150*CKproportion;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 120)];
    footView.backgroundColor = self.view.backgroundColor;
    footView.userInteractionEnabled = YES;
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.backgroundColor = MainColor;
    [sendButton setTitle:@"提  交" forState:UIControlStateNormal];
    [sendButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.view endEditing:YES];
        [MBProgressHUD showSuccess:@"感谢您的反馈"];
    }];
    sendButton.frame = CGRectMake(30, 70, self.view.width - 60, 40);
    sendButton.layer.masksToBounds = YES;
    sendButton.layer.cornerRadius = 4;
    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [footView addSubview:sendButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self.view endEditing:YES];
    }];
    [footView addGestureRecognizer:tap];
    
    return footView;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(15, 15, self.view.width - 30, 200*CKproportion - 30)];
        _textView.delegate = self;
        _textView.text = PlaceText;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.textColor = [UIColor lightGrayColor];
        
    }
    return _textView;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.textView.text isEqualToString:PlaceText]) {
        self.textView.text = @"";
    }else{
        textView.font = [UIFont systemFontOfSize:15];
        textView.textColor = [UIColor blackColor];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.textView.text isEqualToString:@""]) {
        textView.text = PlaceText;
        textView.font = [UIFont systemFontOfSize:15];
        textView.textColor = [UIColor lightGrayColor];
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    textView.font = [UIFont systemFontOfSize:15];
}




@end
