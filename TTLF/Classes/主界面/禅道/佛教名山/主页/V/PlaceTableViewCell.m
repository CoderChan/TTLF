//
//  PlaceTableViewCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/25.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PlaceTableViewCell.h"
#import <Masonry.h>

@interface PlaceTableViewCell ()

@property (strong,nonatomic) UIImageView *backIMGView;

@property (strong,nonatomic) UILabel *titleLabel;


@end

@implementation PlaceTableViewCell


+ (instancetype)sharedDisCoverTableCell:(UITableView *)tableView
{
    static NSString *ID = @"PlaceTableViewCell";
    PlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[PlaceTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    [self.backIMGView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493977380930&di=9baae47ef80caa3f5e48d351c20c883e&imgtype=0&src=http%3A%2F%2Fjiangsu.china.com.cn%2Fuploadfile%2F2014%2F0403%2F20140403072026869.jpg"] placeholderImage:[UIImage imageWithColor:HWRandomColor] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.backIMGView.image = [UIImage boxblurImage:image withBlurNumber:0.1];
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
    self.titleLabel.text = @"舟山普陀山";
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
