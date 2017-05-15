//
//  PlacePicturesController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/11.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PlacePicturesController.h"
#import "PictureCollectionCell.h"
#import "XLPhotoBrowser.h"

#define SpaceNum 2

@interface PlacePicturesController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,XLPhotoBrowserDelegate>

@property (strong,nonatomic) UICollectionView *collectionView;

@property (strong,nonatomic) NSMutableArray *array;

@end

@implementation PlacePicturesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"浏览图集";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.view.backgroundColor = RGBACOLOR(45, 49, 50, 1);
    self.array = [NSMutableArray array];
    for (int i = 0; i < 120; i++) {
        [self.array addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1494607177994&di=2c6a96b6a02076a369c0756a268f0776&imgtype=0&src=http%3A%2F%2Fimg2.yododo.com%2Fmicro%2Fphoto%2F2013-04-17%2F013E1619FCA50183FF8080813E1610D9.jpg"];
    }
    
    UICollectionViewFlowLayout *flayout = [[UICollectionViewFlowLayout alloc]init];
    [flayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flayout.minimumLineSpacing = SpaceNum;
    flayout.minimumInteritemSpacing = SpaceNum;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) collectionViewLayout:flayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[PictureCollectionCell class] forCellWithReuseIdentifier:@"PictureCollectionCell"];
    self.collectionView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.collectionView];
    
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 每行4个，计算宽高
    CGFloat width = (SCREEN_WIDTH - 5*SpaceNum) / 4;
    CGSize size = CGSizeMake(width, width + 5);
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCollectionCell *cell = [PictureCollectionCell sharedCell:collectionView IndexPath:indexPath];
    cell.img_url = self.array[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XLPhotoBrowser *brower = [XLPhotoBrowser showPhotoBrowserWithImages:self.array currentImageIndex:indexPath.row];
    brower.browserStyle = XLPhotoBrowserStyleSimple;
    brower.pageControlStyle = XLPhotoBrowserPageControlStyleNone;
    [brower setActionSheetWithTitle:@"" delegate:self cancelButtonTitle:@"取消" deleteButtonTitle:nil otherButtonTitles:@"发送给朋友",@"保存到相册", nil];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(SpaceNum, SpaceNum, SpaceNum, SpaceNum);
}



@end
