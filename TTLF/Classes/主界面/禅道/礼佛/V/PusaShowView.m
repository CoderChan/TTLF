//
//  PusaShowView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/21.
//  Copyright © 2017年 陈振超. All rights reserved.
//


#import "PusaShowView.h"
#import "HorizontalCollectionCell.h"


@interface PusaShowView ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/** collectionView */
@property (strong, nonatomic) UICollectionView * collectionView;
/** 选中的佛像 */
//@property (strong,nonatomic) FoxiangModel *selectModel;

@end

@implementation PusaShowView

#pragma mark - 初始化
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = RGBACOLOR(0, 0, 0, 0.45);
    [self addSubview:self.collectionView];
}


#pragma mark - 代理方法
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
    FoxiangModel *model = self.array[indexPath.item];
    model.index = indexPath.item;
    HorizontalCollectionCell *cell = [HorizontalCollectionCell sharedCell:collectionView IndexPath:indexPath];
    cell.SelectModelBlock = ^(FoxiangModel *model){
        if ([self.delegate respondsToSelector:@selector(pusaDidSelectFoxiangModel:)]) {
            [_delegate pusaDidSelectFoxiangModel:model];
            [self removeFromSuperview];
        }
    };
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeFromSuperview];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.width, self.height);
}
#pragma mark - 其他方法
- (UICollectionView *)collectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = self.backgroundColor;
        [_collectionView registerClass:[HorizontalCollectionCell class] forCellWithReuseIdentifier:@"HorizontalCollectionCell"];
        
    }
    return _collectionView;
}


@end
