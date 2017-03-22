//
//  MyBooksViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/21.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MyBooksViewController.h"
#import "BookCollectionViewCell.h"
#import <MJRefresh/MJRefresh.h>


#define SpaceNum 8*CKproportion

@interface MyBooksViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
/** 背景图片 */
@property (strong,nonatomic) UIImageView *backImgView;
/** collectionView */
@property (strong,nonatomic) UICollectionView *collectionView;

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
//    self.backImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bookstore_bg"]];
//    self.backImgView.userInteractionEnabled = YES;
//    self.backImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
//    [self.view addSubview:self.backImgView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"book_stores"] style:UIBarButtonItemStylePlain target:self action:@selector(BookStoreAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    [self.view addSubview:self.collectionView];
    
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView.mj_header endRefreshing];
        });
    }];
    
}

#pragma mark - CollectionView代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BookCollectionViewCell *cell = [BookCollectionViewCell sharedCell:collectionView Path:indexPath];
    
    return cell;
    
}

// UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

// 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int HangCount = 3; // 每行多少个
    CGFloat Width = (self.view.width - (HangCount+1) * SpaceNum)/HangCount;
    return CGSizeMake(Width, Width + 38);
}

// 定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(SpaceNum, SpaceNum, SpaceNum, SpaceNum);
}

// 定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return SpaceNum;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}


#pragma mark - 懒加载
- (UICollectionView *)collectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[BookCollectionViewCell class] forCellWithReuseIdentifier:@"BookCollectionViewCell"];
        
    }
    return _collectionView;
}



#pragma mark - 其他方法
- (void)BookStoreAction
{
    
}

@end
