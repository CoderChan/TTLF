//
//  BookStoreViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/1.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "BookStoreViewController.h"
#import "BookStoreTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>
#import "BookDetialViewController.h"
#import "SearchBookVController.h"
#import "BookStoreCacheManager.h"



@interface BookStoreViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    int page; // 当前页码
    int pageNum; // 每页多少条
}

/** 背景图片 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;

@end

@implementation BookStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"藏经阁";
    [self setupSubViews];
}

- (void)setupSubViews
{
    page = 1;
    pageNum = 30;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 120;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.array removeAllObjects];
        page = 1;
        
        [self getBooksInstoreSuccess:^(NSArray *array) {
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
    
    
    // 加载更多
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getBooksInstoreSuccess:^(NSArray *array) {
            [self.tableView.mj_footer endRefreshing];
            [self.array addObjectsFromArray:array];
            [self.tableView reloadData];
        } Fail:^(NSString *errorMsg) {
            [self.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:errorMsg];
        }];
    }];
    
    NSArray *cateArray = [[BookStoreCacheManager sharedManager] getBookCacheArray];
    if (cateArray.count >= 1) {
        [self hideMessageAction];
        [self.array addObjectsFromArray:cateArray];
        [self.tableView reloadData];
        page = 2;
    }else{
        [self.tableView.mj_header beginRefreshing];
    }
    
    // 暗中加载最新的
    [self getNewestDataSuccess:^(NSArray *array) {
        [self.array removeAllObjects];
        [self hideMessageAction];
        [self.array addObjectsFromArray:array];
        [self.tableView reloadData];
    } Fail:^(NSString *errorMsg) {
        [MBProgressHUD showError:errorMsg];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBookAction)];
    
}

// 分页获取佛典书籍
- (void)getBooksInstoreSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Buddist/index";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:[NSString stringWithFormat:@"%d",page].base64EncodedString forKey:@"page"];
    [param setValue:[NSString stringWithFormat:@"%d",pageNum].base64EncodedString forKey:@"pageNum"];
    
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Buddist/index?userID=%@&page=%@&pageNum=%@",account.userID.base64EncodedString,[NSString stringWithFormat:@"%d",page].base64EncodedString,[NSString stringWithFormat:@"%d",pageNum].base64EncodedString];
    NSLog(@"佛典列表 = %@",allurl);
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [responseObject objectForKey:@"message"];
        int totalPage = [[[responseObject objectForKey:@"totalPage"] description] intValue];
        
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
                    NSArray *modelArray = [BookInfoModel mj_objectArrayWithKeyValuesArray:result];
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
                    NSArray *modelArray = [BookInfoModel mj_objectArrayWithKeyValuesArray:result];
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
// 暗中加载最新的
- (void)getNewestDataSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Buddist/index";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:@"1".base64EncodedString forKey:@"page"];
    [param setValue:[NSString stringWithFormat:@"%d",pageNum].base64EncodedString forKey:@"pageNum"];
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [responseObject objectForKey:@"message"];
        
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            NSArray *modelArray = [BookInfoModel mj_objectArrayWithKeyValuesArray:result];
            // 先删再存
            [[BookStoreCacheManager sharedManager] deleBookCache];
            for (int i = 0; i < modelArray.count; i++) {
                BookInfoModel *bookModel = modelArray[i];
                [[BookStoreCacheManager sharedManager] saveBookArrayWithModel:bookModel];
            }
            success(modelArray);
        }else{
            fail(message);
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}


- (void)searchBookAction
{
    SearchBookVController *search = [[SearchBookVController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - CollectionView代理
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
    BookInfoModel *model = self.array[indexPath.row];
    BookStoreTableViewCell *cell = [BookStoreTableViewCell sharedBookStoreCell:tableView];
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

- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

@end
