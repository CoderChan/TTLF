//
//  MyBooksViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/21.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MyBooksViewController.h"
#import "BookStoreViewController.h"
#import "MyBooksTableViewCell.h"
#import "BookDetialViewController.h"
#import "CMPopTipView.h"
#import "BookCacheManager.h"


@interface MyBooksViewController ()<UITableViewDataSource,UITableViewDelegate>

// 表格
@property (strong,nonatomic) UITableView *tableView;
// 数据源
@property (copy,nonatomic) NSArray *array;

@end

#pragma mark - 界面初始化
@implementation MyBooksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的书架";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.view.backgroundColor = RGBACOLOR(199, 148, 66, 1);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"book_stores"] style:UIBarButtonItemStylePlain target:self action:@selector(BookStoreAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    
    self.array = [[BookCacheManager sharedManager] getBookCacheArray];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    if (self.array.count == 0) {
        [self showEmptyViewWithMessage:@"海量佛典\r待您添加"];
    }
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
    MyBooksTableViewCell *cell = [MyBooksTableViewCell sharedBookTableViewCell:tableView];
    BookInfoModel *model = self.array[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BookInfoModel *model = self.array[indexPath.row];
    BookDetialViewController *detial = [[BookDetialViewController alloc]initWithModel:model];
    [self.navigationController pushViewController:detial animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = (SCREEN_HEIGHT - 64) / 4;
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [UIView new];
    foot.backgroundColor = [UIColor clearColor];
    return foot;
}

#pragma mark - 其他方法
- (void)BookStoreAction
{
    BookStoreViewController *bookStore = [BookStoreViewController new];
    [self.navigationController pushViewController:bookStore animated:YES];
}

- (void)tipActionWithMessage:(NSString *)message
{
    CMPopTipView *popTipView = [[CMPopTipView alloc]initWithTitle:nil message:message];
    popTipView.shouldEnforceCustomViewPadding = YES;
    popTipView.backgroundColor = RGBACOLOR(25, 35, 45, 1);
    popTipView.animation = CMPopTipAnimationPop;
    popTipView.dismissTapAnywhere = YES;
    [popTipView autoDismissAnimated:YES atTimeInterval:3];
    popTipView.textColor = [UIColor whiteColor];
    [popTipView presentPointingAtBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.array = [[BookCacheManager sharedManager] getBookCacheArray];
    if (self.array.count > 0) {
        [self hideMessageAction];
    }
    [self.tableView reloadData];
}

@end
