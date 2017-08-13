//
//  FoNewsViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/1/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "FoNewsViewController.h"
#import "NewsTableViewCell.h"
#import "DetialNewsViewController.h"
#import <MJRefresh.h>
#import <Masonry.h>
#import <StoreKit/StoreKit.h>
#import <MJExtension/MJExtension.h>
#import "NewsCacheManager.h"
#import "PhoneViewController.h"
#import "RootNavgationController.h"


@interface FoNewsViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,SKStoreProductViewControllerDelegate>
{
    int CurrentPage; // 当前页
    int PageNum; // 每页多少条
}
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;
/** 搜索控制器 */
@property (nonatomic,strong) UISearchController *searchController;


@end

@implementation FoNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佛界头条";
    [self setupSubViews];
}
#pragma mark - 界面初始化
- (void)setupSubViews
{
    CurrentPage = 1;
    PageNum = 10;
    
    self.array = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 100;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openAppStoreAction)];
    
    
    // 下拉加载，每次加载最新的。
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        CurrentPage = 1;
        [self.array removeAllObjects];
        [self getArticleCurrentPage:CurrentPage Success:^(NSArray *modelArray) {
            
            [self hideMessageAction];
            [self.tableView.mj_header endRefreshing];
            [self.array addObjectsFromArray:modelArray];
            [self.tableView reloadData];
            
        } Fail:^(NSString *errorMsg) {
            CurrentPage = 1;
            [self.tableView.mj_header endRefreshing];
            [self showEmptyViewWithMessage:errorMsg];
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UserInfoModel *userModel = [[UserInfoManager sharedManager] getUserInfo];
        if (![userModel.phoneNum isPhoneNum]) {
            [self showTwoAlertWithMessage:@"感谢使用佛缘生活APP，我们极力推荐您设置已绑定微信的手机号码，以方便加入佛缘生活微信群，当然，您可以自由退出。是否继续？" ConfirmClick:^{
                PhoneViewController *phone = [[PhoneViewController alloc]init];
                phone.isPresent = YES;
                RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:phone];
                [self presentViewController:nav animated:YES completion:^{
                    
                }];
            }];
        }
    });
}

- (void)openAppStoreAction
{
    SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
    [storeProductVC.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    storeProductVC.delegate = self;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"1212776820" forKey:SKStoreProductParameterITunesItemIdentifier];
    [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error)
     {
         if (result)
         {
             [self presentViewController:storeProductVC animated:YES completion:nil];
         }
     }];
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
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
    
    NSString *url = [NSString stringWithFormat:@"http://app.yangruyi.com/home/News/index/p/%d",currentPage];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:pageNumStr forKey:@"pageNum"];
    
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/Home/News/index?userID=%@&currentPage=%@&pageNum=%@",account.userID.base64EncodedString,page,pageNumStr];
    NSLog(@"获取文章链接 = %@",allurl);
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
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
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer endRefreshing];
                }else{
                    CurrentPage++;
                    NSArray *modelArray = [NewsArticleModel mj_objectArrayWithKeyValuesArray:result];
                    
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
                    NSArray *modelArray = [NewsArticleModel mj_objectArrayWithKeyValuesArray:result];
                    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsArticleModel *model = self.array[indexPath.row];
    NewsTableViewCell *cell = [NewsTableViewCell sharedNewsCell:tableView];
    cell.model = model;
    
    return cell;
}

- (void)skks:(NewsArticleModel *)model
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetialNewsViewController *news = [DetialNewsViewController new];
    news.newsModel = self.array[indexPath.row];
    [self.navigationController pushViewController:news animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}
#pragma mark - 其他方法
- (void)douleClickReloadAction
{
    [self.tableView.mj_header beginRefreshing];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

@end
