//
//  SelectTopicController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/3/1.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SelectTopicController.h"
#import "TopicCollectionCell.h"
#import <MJRefresh.h>
#import <Masonry.h>


#define topViewH 100*CKproportion
#define spaceNum 8

@interface SelectTopicController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/** collectionView */
@property (strong,nonatomic) UICollectionView *collectionView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 顶部图片 */
@property (strong,nonatomic) UIView *topView;
/** 十万个为什么 */
@property (strong,nonatomic) UILabel *whyLabel;

@end

@implementation SelectTopicController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择话题";
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    [self.view addSubview:self.collectionView];
    
    [self.collectionView insertSubview:self.topView atIndex:0];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.collectionView.mj_header endRefreshing];
    }];
    
    
    [[TTLFManager sharedManager].networkManager getTopicListSuccess:^(NSArray *array) {
        self.array = array;
        [self.collectionView reloadData];
        SendTopicModel *model = [self.array firstObject];
        self.whyLabel.text = model.topic_name;
    } Fail:^(NSString *errorMsg) {
        [self sendAlertAction:errorMsg];
    }];
    
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count - 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SendTopicModel *topicModel = self.array[indexPath.row + 1];
    TopicCollectionCell *cell = [TopicCollectionCell sharedTopicCollectionCell:collectionView Path:indexPath];
    cell.topicModel = topicModel;
    return cell;
    
}
// UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SendTopicModel *topicModel = self.array[indexPath.row + 1];
    if (self.SelectModelBlock) {
        _SelectModelBlock(topicModel);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat Width = (self.view.width - spaceNum *3)/2;
    return CGSizeMake(Width, 60);
}

// 定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(spaceNum, spaceNum, spaceNum*2, spaceNum);
}

// 定义每个UICollectionView 纵向的间距

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return spaceNum;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return spaceNum;
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, -21, self.view.width, self.view.height - 44) collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        self.view.backgroundColor = self.view.backgroundColor;
        _collectionView.backgroundColor = self.view.backgroundColor;
        [_collectionView registerClass:[TopicCollectionCell class] forCellWithReuseIdentifier:@"TopicCollectionCell"];
        _collectionView.contentInset = UIEdgeInsetsMake(topViewH, 0, 0, 0);
    }
    return _collectionView;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, -topViewH, self.view.width, topViewH)];
        _topView.userInteractionEnabled = YES;
        _topView.backgroundColor = self.view.backgroundColor;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            SendTopicModel *topicModel = self.array.firstObject;
            if (self.SelectModelBlock) {
                _SelectModelBlock(topicModel);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        [_topView addGestureRecognizer:tap];
        
    }
    return _topView;
}
- (UILabel *)whyLabel
{
    if (!_whyLabel) {
        _whyLabel = [[UILabel alloc]init];
        _whyLabel.textAlignment = NSTextAlignmentCenter;
        _whyLabel.backgroundColor = MainColor;
        _whyLabel.font = [UIFont boldSystemFontOfSize:24];
        _whyLabel.textColor = [UIColor whiteColor];
        [self.topView addSubview:self.whyLabel];
        CGFloat Width = (self.view.width - spaceNum *3)/2;
        CGFloat Height = 60;
        [_whyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.topView.mas_centerX);
            make.bottom.equalTo(self.topView.mas_bottom);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(Height));
        }];
    }
    return _whyLabel;
}


@end
