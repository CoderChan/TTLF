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


#define TopViewH 180*CKproportion
#define Space 3

@interface MusicListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

/** UICollectionView */
@property (strong,nonatomic) UICollectionView *collectionView;
/** 数据源--最新模板 */
@property (copy,nonatomic) NSArray *array;

@end

@implementation MusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"梵音";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = BackColor;
    // 表格
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = self.view.backgroundColor;
    [self.collectionView registerClass:[MusicCollectionViewCell class] forCellWithReuseIdentifier:@"MusicCollectionViewCell"];
    [self.view addSubview:self.collectionView];
    
    // 右侧播放按钮
    PlayingRightBarView *play = [[PlayingRightBarView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    play.ClickBlock = ^{
        MusicPlayingController *musicPlaying = [[MusicPlayingController alloc]init];
        [self.navigationController pushViewController:musicPlaying animated:YES];
    };
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:play];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return self.array.count;
    return 40;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MusicCollectionViewCell *cell = [MusicCollectionViewCell sharedCell:collectionView Path:indexPath];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumListViewController *album = [[AlbumListViewController alloc]init];
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




@end
