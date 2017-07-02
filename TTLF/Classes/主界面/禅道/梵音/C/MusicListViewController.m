//
//  MusicListViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/6/18.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MusicListViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "MusicCollectionViewCell.h"
#import "AlbumListViewController.h"
#import "MusicPlayingController.h"
#import "PlayingRightBarView.h"
#import <MJExtension/MJExtension.h>
#import "RootNavgationController.h"


#define TopViewH 180*CKproportion
#define Space 5

@interface MusicListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    int page; // 当前页
    int pageNum; // 每页多少条
}
/** UICollectionView */
@property (strong,nonatomic) UICollectionView *collectionView;
/** 数据源--最新模板 */
@property (strong,nonatomic) NSMutableArray *array;

@end

@implementation MusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"梵音";
    [self setupSubViews];
}

- (void)setupSubViews
{
    page = 1;
    pageNum = 10;
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    // 表格
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = self.view.backgroundColor;
    [self.collectionView registerClass:[MusicCollectionViewCell class] forCellWithReuseIdentifier:@"MusicCollectionViewCell"];
    [self.view addSubview:self.collectionView];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.array removeAllObjects];
        page = 1;
        
        [self getMusicCateSuccess:^(NSArray *array) {
            [self.collectionView.mj_header endRefreshing];
            [self hideMessageAction];
            [self.array addObjectsFromArray:array];
            [self.collectionView reloadData];
        } Fail:^(NSString *errorMsg) {
            page = 1;
            [self.collectionView.mj_header endRefreshing];
            [self showEmptyViewWithMessage:errorMsg];
        }];
    }];
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getMusicCateSuccess:^(NSArray *array) {
            [self.collectionView.mj_footer endRefreshing];
            [self.array addObjectsFromArray:array];
            [self.collectionView reloadData];
        } Fail:^(NSString *errorMsg) {
            [self.collectionView.mj_footer endRefreshing];
            [MBProgressHUD showError:errorMsg];
        }];
    }];
}

#pragma mark - 获取数据
- (void)getMusicCateSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://app.yangruyi.com/home/Music/index";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID.base64EncodedString forKey:@"userID"];
    [param setValue:[NSString stringWithFormat:@"%d",page].base64EncodedString forKey:@"page"];
    [param setValue:[NSString stringWithFormat:@"%d",pageNum].base64EncodedString forKey:@"pageNum"];
    
    NSString *allurl = [NSString stringWithFormat:@"http://app.yangruyi.com/home/Music/index?userID=%@&page=%@&pageNum=%@",account.userID.base64EncodedString,[NSString stringWithFormat:@"%d",page].base64EncodedString,[NSString stringWithFormat:@"%d",pageNum].base64EncodedString];
    NSLog(@"梵音分类列表 = %@",allurl);
    
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
                    [self.collectionView.mj_header endRefreshing];
                    [self.collectionView.mj_footer endRefreshing];
                }else{
                    page++;
                    NSArray *result = [responseObject objectForKey:@"result"];
                    NSArray *modelArray = [MusicCateModel mj_objectArrayWithKeyValuesArray:result];
                    success(modelArray);
                }
            }else{
                // 没有整除，总页数=商+1
                int sumPage = totalPage/pageNum + 1;
                if (page > sumPage) {
                    // 没有更多的了
                    [MBProgressHUD showNormal:@"暂无更多"];
                    [self.collectionView.mj_header endRefreshing];
                    [self.collectionView.mj_footer endRefreshing];
                }else{
                    page++;
                    NSArray *result = [responseObject objectForKey:@"result"];
                    NSArray *modelArray = [MusicCateModel mj_objectArrayWithKeyValuesArray:result];
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
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MusicCollectionViewCell *cell = [MusicCollectionViewCell sharedCell:collectionView Path:indexPath];
    MusicCateModel *model = self.array[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MusicCateModel *model = self.array[indexPath.row];
    AlbumListViewController *album = [[AlbumListViewController alloc]initWithModel:model];
    [self.navigationController pushViewController:album animated:YES];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (self.view.width - 3*Space)/2;
    CGFloat height = width + 50;
    return CGSizeMake(width, height);
}
// 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// 定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(Space, Space, Space, Space);
}

// 定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return Space;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return Space;
}
- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}



@end
