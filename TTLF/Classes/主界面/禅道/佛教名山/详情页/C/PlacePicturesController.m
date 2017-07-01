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
#import "PYPhotosReaderController.h"

#define SpaceNum 2

@interface PlacePicturesController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/** 表格 */
@property (strong,nonatomic) UICollectionView *collectionView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;
/** 景区模型 */
@property (strong,nonatomic) PlaceDetialModel *placeModel;

@end


@implementation PlacePicturesController


- (instancetype)initWithModel:(PlaceDetialModel *)placeModel
{
    self = [super init];
    if (self) {
        self.placeModel = placeModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"浏览图集";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.view.backgroundColor = RGBACOLOR(45, 49, 50, 1);
    
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
    
    [[TTLFManager sharedManager].networkManager placePicturesWithModel:self.placeModel Success:^(NSArray *array) {
        [self hideMessageAction];
        self.collectionView.hidden = NO;
        [self.array addObjectsFromArray:array];
        [self.collectionView reloadData];
    } Fail:^(NSString *errorMsg) {
        self.collectionView.hidden = YES;
        [self showEmptyViewWithMessage:errorMsg];
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
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(SpaceNum, SpaceNum, SpaceNum, SpaceNum);
}

- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

#pragma mark - 图片浏览器
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = CGRectZero;
    for (int i = 0; i < self.array.count; i++) {
        UICollectionViewCell *cell = collectionView.subviews[indexPath.row];
        frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y + 64, cell.frame.size.width, cell.frame.size.height);
    }
    
    NSLog(@"X = %f,Y = %f, W = %f,H = %f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    
    XLPhotoBrowser *brower = [XLPhotoBrowser showPhotoBrowserWithImages:self.array currentImageIndex:indexPath.row];
    brower.browserStyle = XLPhotoBrowserStyleSimple;
    brower.pageControlStyle = XLPhotoBrowserPageControlStyleAnimated;
    [brower show];
    
    
}


@end
