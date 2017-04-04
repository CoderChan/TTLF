//
//  DiscoverViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2016/11/24.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "DiscoverViewController.h"
#import "PlaceListViewController.h"
#import "DiscoverCollectionCell.h"
#import "HomeReusableView.h"
#import "GoodsDetialController.h"
#import <MJRefresh.h>
#import <SVWebViewController.h>


#define TopViewH 210*CKproportion
#define SpaceNum 4

@interface DiscoverViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>



/** collectionView */
@property (strong,nonatomic) UICollectionView *collectionView;
/** 顶部图片 */
@property (strong,nonatomic) UIImageView *topView;


@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
    [self setupSubViews];
    
}

- (void)setupSubViews
{
    self.view.backgroundColor = RGBACOLOR(250, 246, 232, 1);
    [self.view addSubview:self.collectionView];
    
    [self.collectionView insertSubview:self.topView atIndex:0];
    
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
    }];
    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else{
        return 30;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DiscoverCollectionCell *cell = [DiscoverCollectionCell sharedCell:collectionView Path:indexPath];
    return cell;
    
}

// UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    GoodsDetialController *place = [GoodsDetialController new];
//    [self.navigationController pushViewController:place animated:YES];
    SVWebViewController *taobao = [[SVWebViewController alloc]initWithAddress:TaobaoGoodsURL];
    taobao.title = @"饰品详情";
    [self.navigationController pushViewController:taobao animated:YES];
    
    
}

// 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat Width = (self.view.width - SpaceNum * 3)/2;
    return CGSizeMake(Width, Width + 45);
}

// 定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(SpaceNum, SpaceNum, SpaceNum, SpaceNum);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * reusableview = nil;
    if(kind == UICollectionElementKindSectionHeader){
        
        NSArray *titleArr = @[@"佛教胜地",@"精品佛饰"];
        HomeReusableView * headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeReusableView" forIndexPath:indexPath];
        headerview.DidClickBlock = ^(){
            PlaceListViewController *place = [PlaceListViewController new];
            [self.navigationController pushViewController:place animated:YES];
        };
        headerview.title = titleArr[indexPath.section];
        reusableview = headerview;
        
    }
    return reusableview;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.width, 40);
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = SpaceNum;
    flowLayout.minimumInteritemSpacing = SpaceNum;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, -21, self.view.width, self.view.height - 44) collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = self.view.backgroundColor;
        [_collectionView registerClass:[DiscoverCollectionCell class] forCellWithReuseIdentifier:@"DiscoverCollectionCell"];
        _collectionView.contentInset = UIEdgeInsetsMake(TopViewH, 0, 0, 0);
        [_collectionView registerClass:[HomeReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeReusableView"];
    }
    return _collectionView;
}

- (UIImageView *)topView
{
    if (!_topView) {
        _topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -TopViewH, self.view.width, TopViewH)];
        _topView.userInteractionEnabled = YES;
        [_topView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490949352798&di=a1030c130b3757ed61f5b90916b9a375&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fw%253D580%2Fsign%3De6a4c004f01f3a295ac8d5c6a927bce3%2Fc2528c1001e939014bcfece47bec54e734d196a2.jpg"] placeholderImage:[UIImage imageNamed:@"nian_sy_bg"]];
        _topView.backgroundColor = MainColor;
        _topView.autoresizingMask = YES;
    }
    return _topView;
}


@end
