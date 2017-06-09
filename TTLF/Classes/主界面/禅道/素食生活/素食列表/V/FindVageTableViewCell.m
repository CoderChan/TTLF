//
//  FindVageTableViewCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/29.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "FindVageTableViewCell.h"
#import <Masonry.h>


@interface FindVageTableViewCell ()

/** 封面 */
@property (strong,nonatomic) UIImageView *coverImgView;
/** 菜谱名称 */
@property (strong,nonatomic) UILabel *vageNameLabel;
/** 发布人头像 */
@property (strong,nonatomic) UIImageView *headImgView;
/** 发布人昵称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 简述 */
@property (strong,nonatomic) UILabel *storyLabel;

@end

@implementation FindVageTableViewCell

+ (instancetype)sharedFindVageCell:(UITableView *)tableView
{
    static NSString *ID = @"FindVageTableViewCell";
    FindVageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[FindVageTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setVegeModel:(VegeInfoModel *)vegeModel
{
    _vegeModel = vegeModel;
    _vageNameLabel.text = vegeModel.vege_name;
    _storyLabel.text = vegeModel.vege_desc;
    [_coverImgView sd_setImageWithURL:[NSURL URLWithString:vegeModel.vege_img] placeholderImage:[UIImage imageWithColor:RGBACOLOR(63, 72, 123, 1)]];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:vegeModel.creater_head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    _nameLabel.text = vegeModel.creater_name;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    // 封面
    self.coverImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vage_place"]];
    self.coverImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 220*CKproportion);
    self.coverImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.coverImgView setContentScaleFactor:[UIScreen mainScreen].scale];
    self.coverImgView.layer.masksToBounds = YES;
    self.coverImgView.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.coverImgView];
    
    // 名称
    self.vageNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.coverImgView.frame) + 10, self.coverImgView.width - 20, 25)];
    self.vageNameLabel.text = @"小葱拌豆腐";
    self.vageNameLabel.font = [UIFont boldSystemFontOfSize:20];
    self.vageNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.vageNameLabel];
    
    // 发布人
    self.headImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_place"]];
    self.headImgView.frame = CGRectMake(SCREEN_WIDTH/2 - 35, CGRectGetMaxY(self.vageNameLabel.frame) + 8, 20, 20);
    self.headImgView.layer.cornerRadius = 10;
    self.headImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.headImgView setContentScaleFactor:[UIScreen mainScreen].scale];
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.headImgView];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImgView.frame) + 3, self.headImgView.y, 200, 21)];
    self.nameLabel.text = @"我在普陀山下";
    self.nameLabel.textColor = RGBACOLOR(108, 108, 108, 1);
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.nameLabel];
    
    // 故事描述
    self.storyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.headImgView.frame), SCREEN_WIDTH - 40, 50)];
    self.storyLabel.numberOfLines = 2;
    self.storyLabel.text = @"莫斯科蛇口蛇口开始看蛇口蛇口伤口上看看试试看。沙漠死神所所木所扩所扩所扩所扩什么什么萨克斯。。。";
    self.storyLabel.font = [UIFont systemFontOfSize:14];
    self.storyLabel.textColor = RGBACOLOR(45, 45, 45, 1);
    [self.contentView addSubview:self.storyLabel];
    
    
}


@end
