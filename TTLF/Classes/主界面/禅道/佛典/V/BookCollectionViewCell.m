//
//  BookCollectionViewCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/21.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "BookCollectionViewCell.h"
#import <Masonry.h>

@interface BookCollectionViewCell ()

@property (strong,nonatomic) UIImageView *bookImgView;

@end


@implementation BookCollectionViewCell


+ (instancetype)sharedCell:(UICollectionView *)collectionView Path:(NSIndexPath *)indexPath
{
    static NSString *ID = @"BookCollectionViewCell";
    BookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[BookCollectionViewCell alloc]init];
    }
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
    }
    return self;
}


- (void)setupSubViews
{
//    gy_book_cell
    self.bookImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gy_book_cell"]];
    [self.contentView addSubview:self.bookImgView];
    [self.bookImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.mas_left).offset(3);
        make.top.equalTo(self.mas_top).offset(4);
    }];
}

@end
