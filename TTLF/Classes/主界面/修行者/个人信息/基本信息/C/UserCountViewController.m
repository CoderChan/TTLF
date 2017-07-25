//
//  UserCountViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/7/4.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "UserCountViewController.h"
#import "AllUserTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>
#import "VisitUserViewController.h"


@interface UserCountViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    int page; // 当前页码
    int pageNum; // 每页多少条
}

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *array;

@end

@implementation UserCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户统计";
    [self setupSubViews];
}

- (void)setupSubViews
{
    page = 1;
    pageNum = 80;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 60;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.array removeAllObjects];
        page = 1;
        
        [self getAllUsersSuccess:^(NSArray *array) {
            [self.tableView.mj_header endRefreshing];
            [self hideMessageAction];
            [self.array addObjectsFromArray:array];
            [self.tableView reloadData];
        } Fail:^(NSString *errorMsg) {
            page = 1;
            [self showEmptyViewWithMessage:errorMsg];
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getAllUsersSuccess:^(NSArray *array) {
            [self.tableView.mj_footer endRefreshing];
            [self.array addObjectsFromArray:array];
            [self.tableView reloadData];
        } Fail:^(NSString *errorMsg) {
            [self.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:errorMsg];
        }];
    }];
}

- (void)getAllUsersSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    
    NSString *url = @"http://app.yangruyi.com/home/Index/showAllUser";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:[NSString stringWithFormat:@"%d",page].base64EncodedString forKey:@"page"];
    [param setValue:[NSString stringWithFormat:@"%d",pageNum].base64EncodedString forKey:@"pageNum"];
    
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Index/showAllUser?userID=%@&page=%@&pageNum=%@",account.userID.base64EncodedString,[NSString stringWithFormat:@"%d",page].base64EncodedString,[NSString stringWithFormat:@"%d",pageNum].base64EncodedString];
    NSLog(@"用户列表 = %@",allurl);
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [responseObject objectForKey:@"message"];
        int totalPage = [[[responseObject objectForKey:@"totalPage"] description] intValue];
        self.title = [NSString stringWithFormat:@"共%@用户",[[responseObject objectForKey:@"totalPage"] description]];
        
        if (code == 1) {
            int yushu = totalPage % pageNum;
            if (yushu == 0) {
                // 正好整除
                int sumPage = totalPage/pageNum;
                if (page > sumPage) {
                    // 没有更多的了
                    [MBProgressHUD showNormal:@"暂无更多"];
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer endRefreshing];
                }else{
                    page++;
                    NSArray *result = [responseObject objectForKey:@"result"];
                    NSArray *modelArray = [AllUserModel mj_objectArrayWithKeyValuesArray:result];
                    success(modelArray);
                }
            }else{
                // 没有整除，总页数=商+1
                int sumPage = totalPage/pageNum + 1;
                if (page > sumPage) {
                    // 没有更多的了
                    [MBProgressHUD showNormal:@"暂无更多"];
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer endRefreshing];
                }else{
                    page++;
                    NSArray *result = [responseObject objectForKey:@"result"];
                    NSArray *modelArray = [AllUserModel mj_objectArrayWithKeyValuesArray:result];
                    success(modelArray);
                }
            }
            
        }else{
            fail(message);
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
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
    AllUserModel *model = self.array[indexPath.row];
    AllUserTableViewCell *cell = [AllUserTableViewCell sharedCell:tableView];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AllUserModel *model = self.array[indexPath.row];
    VisitUserViewController *visit = [[VisitUserViewController alloc]initWithUserID:model.userid];
    [self.navigationController pushViewController:visit animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [UIView new];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectZero];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}

- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}


@end
