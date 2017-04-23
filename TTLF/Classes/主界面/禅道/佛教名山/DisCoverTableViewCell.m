//
//  DisCoverTableViewCell.m
//  FYQ
//
//  Created by Chan_Sir on 2016/12/19.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "DisCoverTableViewCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>


@interface DisCoverTableViewCell ()

@property (strong,nonatomic) UIImageView *backIMGView;

@property (strong,nonatomic) UILabel *titleLabel;

@end

@implementation DisCoverTableViewCell



+ (instancetype)sharedDisCoverTableCell:(UITableView *)tableView
{
    static NSString *ID = @"DisCoverTableViewCell";
    DisCoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[DisCoverTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        
        [self setupSubViews];
    }
    return self;
}



- (void)setupSubViews
{
    self.backIMGView = [[UIImageView alloc]initWithImage:[UIImage imageWithColor:HWRandomColor]];
    [self.backIMGView sd_setImageWithURL:[NSURL URLWithString:@"http://img010.hc360.cn/g6/M05/C1/60/wKhQr1Qd3_uEL2s3AAAAAB2B8rI771.jpg"] placeholderImage:[UIImage imageWithColor:HWRandomColor] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.backIMGView.image = [UIImage boxblurImage:image withBlurNumber:0.8];
    }];
    self.backIMGView.layer.masksToBounds = YES;
    self.backIMGView.layer.cornerRadius = 4;
    [self.contentView addSubview:self.backIMGView];
    [self.backIMGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(4);
        make.right.equalTo(self.contentView.mas_right).offset(-4);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"108📿念珠";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backIMGView.mas_left);
        make.right.equalTo(self.backIMGView.mas_right);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@30);
    }];
    
}

@end
