//
//  ChangePusaViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/1/21.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "ChangePusaViewController.h"
#import "NormalTableViewCell.h"

@interface ChangePusaViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *array;

@end

@implementation ChangePusaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择菩萨";
    [self setupSubViews];
}

- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"dismiss"] style:UIBarButtonItemStylePlain target:self action:@selector(Dismiss)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)Dismiss
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 60;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    }
    return _tableView;
}


@end
