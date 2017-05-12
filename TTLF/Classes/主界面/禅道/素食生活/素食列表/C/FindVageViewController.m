//
//  FindVageViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/23.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "FindVageViewController.h"
#import "FindVageTableViewCell.h"
#import "SearchVageViewController.h"
#import "VageDetialViewController.h"
#import <MJRefresh.h>
#import "RootNavgationController.h"
#import <MJExtension/MJExtension.h>


@interface FindVageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int CurrentPage; // 当前页
    int PageNum; // 每页多少条
}

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;


@end

@implementation FindVageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"精选素食";
    [self setupSubViews];
}
#pragma mark - 绘制界面和加载数据
- (void)setupSubViews
{
    CurrentPage = 1;
    PageNum = 2;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.array = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.bounds.size.height - 64)];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction)];
    
    // 下拉加载，每次加载最新的。
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        CurrentPage = 1;
        [self.array removeAllObjects];
        [self getArticleCurrentPage:CurrentPage Success:^(NSArray *modelArray) {
            
            [self.array addObjectsFromArray:modelArray];
            [self.tableView reloadData];
            
        } Fail:^(NSString *errorMsg) {
            CurrentPage = 1;
            [MBProgressHUD showError:errorMsg];
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    // 上拉加载更多
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getArticleCurrentPage:CurrentPage Success:^(NSArray *modelArray) {
            [self.tableView.mj_footer endRefreshing];
            [self.array addObjectsFromArray:modelArray];
            [self.tableView reloadData];
        } Fail:^(NSString *errorMsg) {
            [self.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:errorMsg];
        }];
    }];
}

#pragma mark - 获取数据
- (void)getArticleCurrentPage:(int)currentPage Success:(void (^)(NSArray *modelArray))success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    
    NSString *page = [NSString stringWithFormat:@"%d",currentPage].base64EncodedString;
    NSString *pageNumStr = [NSString stringWithFormat:@"%d",PageNum].base64EncodedString;
    
    
    
    NSString *url = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Vegetarian/index/p/%d",currentPage];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:pageNumStr forKey:@"pageNum"];
    [param setValue:page forKey:@"currentPage"];
    
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Vegetarian/index?userID=%@&currentPage=%@&pageNum=%@",account.userID.base64EncodedString,page,pageNumStr];
    NSLog(@"获取素食链接 = %@",allurl);
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        [self.tableView.mj_header endRefreshing];
        // 总文章数
        int totalPage = [[[responseObject objectForKey:@"totalPage"] description] intValue];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            int yushu = totalPage % PageNum;
            
            if (yushu == 0) {
                // 正好整除，总页数是他们的商
                int sumPage = totalPage/PageNum;
                if (CurrentPage > sumPage) {
                    // 没有更多的了
                    [MBProgressHUD showNormal:@"暂无更多"];
                    [self.tableView.mj_footer endRefreshing];
                }else{
                    CurrentPage++;
                    NSArray *modelArray = [VegeInfoModel mj_objectArrayWithKeyValuesArray:result];
                    success(modelArray);
                }
            }else{
                // 没有整除，总页数=商+1
                int sumPage = totalPage/PageNum + 1;
                if (CurrentPage > sumPage) {
                    // 没有更多的了
                    [MBProgressHUD showNormal:@"暂无更多"];
                    [self.tableView.mj_footer endRefreshing];
                }else{
                    CurrentPage++;
                    NSArray *modelArray = [VegeInfoModel mj_objectArrayWithKeyValuesArray:result];
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


#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindVageTableViewCell *cell = [FindVageTableViewCell sharedFindVageCell:tableView];
    VegeInfoModel *model = self.array[indexPath.section];
    cell.vegeModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VegeInfoModel *vegeModel = self.array[indexPath.section];
    VageDetialViewController *vageDetial = [[VageDetialViewController alloc]initWithVegeModel:vegeModel];
    [self.navigationController pushViewController:vageDetial animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220*CKproportion + 10 + 25 + 28 + 50 + 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}


#pragma mark - 其他方法
- (void)searchAction
{
//    SearchVageViewController *search = [SearchVageViewController new];
//    RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:search];
//    [self presentViewController:nav animated:NO completion:^{
//        
//    }];
    
    SearchVageViewController *search = [SearchVageViewController new];
    [self.navigationController pushViewController:search animated:YES];
}

@end
