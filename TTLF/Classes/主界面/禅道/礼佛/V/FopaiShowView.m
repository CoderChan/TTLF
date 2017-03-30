//
//  FopaiShowView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/28.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "FopaiShowView.h"
#import "FopaiCollectionViewCell.h"


#define SpaceNum 10
#define HangCout 4
#define LieCount 4

@interface FopaiShowView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic) UICollectionView *collectionView;

@end

@implementation FopaiShowView

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
    FopaiModel *model = self.array[indexPath.row];
    FopaiCollectionViewCell *cell = [FopaiCollectionViewCell sharedCell:collectionView IndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FopaiModel *model = self.array[indexPath.row];
    [[TTLFManager sharedManager].networkManager everydayLifoWithFopai:model Success:^{
        if ([self.delegate respondsToSelector:@selector(fopaiDidSelectFopaiModel:)]) {
            [_delegate fopaiDidSelectFopaiModel:model];
            [self removeFromSuperview];
        }
    } Fail:^(NSString *errorMsg) {
        [MBProgressHUD showError:errorMsg];
    }];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(40*CKproportion, 80*CKproportion);
    return size;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(SpaceNum, SpaceNum, SpaceNum, SpaceNum);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return SpaceNum;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return SpaceNum;
}
- (UICollectionView *)collectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = SpaceNum;
    flowLayout.minimumInteritemSpacing = SpaceNum;
    
    CGFloat Fwidth = 40*CKproportion;
    CGFloat Fheight = 80*CKproportion;
    CGFloat Width = SCREEN_WIDTH - (Fwidth * HangCout + SpaceNum * (HangCout - 1)) + Fwidth;
    CGFloat Height = SCREEN_HEIGHT - (Fheight * LieCount + SpaceNum * (LieCount + 1)) + Fheight;
    CGFloat X = (SCREEN_WIDTH - Width)/2;
    CGFloat Y = (SCREEN_HEIGHT - Height)/2;
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(X, Y, Width, Height) collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[FopaiCollectionViewCell class] forCellWithReuseIdentifier:@"FopaiCollectionViewCell"];
    }
    return _collectionView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

@end
