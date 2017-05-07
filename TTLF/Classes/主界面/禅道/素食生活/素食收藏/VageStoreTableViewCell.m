//
//  VageStoreTableViewCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/6.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "VageStoreTableViewCell.h"
#import <Masonry.h>


@interface VageStoreTableViewCell ()

/** 封面 */
@property (strong,nonatomic) UIImageView *coverImgView;
/** 发布者昵称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 发布者头像 */
@property (strong,nonatomic) UIImageView *headImgView;
/** 素食名称 */
@property (strong,nonatomic) UILabel *vageNameLabel;
/** 素食简称 */
@property (strong,nonatomic) UILabel *vageDescLabel;
/** 收藏的时间 */
@property (strong,nonatomic) UILabel *timeLabel;


@end

@implementation VageStoreTableViewCell

+ (instancetype)sharedVageCell:(UITableView *)tableView
{
    static NSString *ID = @"VageStoreTableViewCell";
    VageStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[VageStoreTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    // 发布者头像
    self.headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 30, 30)];
    self.headImgView.image = [UIImage imageWithColor:HWRandomColor];
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = 15;
    [self.contentView addSubview:self.headImgView];
    
    // 发布者昵称
    self.vageNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImgView.frame) + 5, 10, 100, 30)];
    self.vageNameLabel.text = @"周顺雷";
    self.vageNameLabel.font = [UIFont systemFontOfSize:15];
    self.vageNameLabel.textColor = RGBACOLOR(67, 67, 67, 1);
    [self.contentView addSubview:self.vageNameLabel];
    
    // 收藏时间
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 10, 80, 30)];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.text = @"2017/05/12";
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = RGBACOLOR(87, 87, 87, 1);
    [self.contentView addSubview:self.timeLabel];
    
    // 封面
    self.coverImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.headImgView.frame) + 15, 150 * CKproportion, 110 * CKproportion)];
    self.coverImgView.image = [UIImage imageWithColor:HWRandomColor];
    [self.contentView addSubview:self.coverImgView];
    
    // 素食名称
    self.vageNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.vageNameLabel.numberOfLines = 0;
    self.vageNameLabel.text = @"说明书看说明书上什么什么萨克斯没事上马赛克马上开始";
    [self.contentView addSubview:self.vageNameLabel];
    [self.vageNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImgView.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.coverImgView.mas_centerY);
    }];
    
    
}

@end
