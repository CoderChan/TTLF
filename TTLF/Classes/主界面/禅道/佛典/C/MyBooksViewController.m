//
//  MyBooksViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/21.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MyBooksViewController.h"
#import "BookStoreViewController.h"
#import "BookTableViewCell.h"



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
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookTableViewCell *cell = [BookTableViewCell sharedBookTableViewCell:tableView];
    if (indexPath.row == 0) {
        // 加书本
        for (int i = 0; i < 3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"gy_book_cell"] forState:UIControlStateNormal];
            CGFloat space = 30;
            CGFloat W = (SCREEN_WIDTH - 4*space)/3;
            CGFloat X = (i%3) * (W + space) + space;
            CGFloat Y = 15;
            CGFloat H = (SCREEN_HEIGHT - 64) / 4 - 30;
            [button setFrame:CGRectMake(X, Y, W, H)];
            [cell addSubview:button];
        }
        
    }
    return cell;
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
