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


@interface MyBooksViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UITableView *tableView;

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
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGBACOLOR(199, 148, 66, 1);
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyBooksTableViewCell *cell = [MyBooksTableViewCell sharedBookTableViewCell:tableView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BookDetialViewController *detial = [BookDetialViewController new];
    [self.navigationController pushViewController:detial animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = (SCREEN_HEIGHT - 64) / 4;
    return height;
}


#pragma mark - 其他方法
- (void)BookStoreAction
{
    BookStoreViewController *bookStore = [BookStoreViewController new];
    [self.navigationController pushViewController:bookStore animated:YES];
}

@end
