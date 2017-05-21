//
//  PlaceDiscussTableCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PlaceDiscussTableCell.h"
#import <Masonry.h>
#import "PYPhotosView.h"

@interface PlaceDiscussTableCell ()

/** 头像 */
@property (strong,nonatomic) UIImageView *headImgView;
/** 昵称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 内容 */
@property (strong,nonatomic) UILabel *contentLabel;
/** 附图 */
@property (strong,nonatomic) PYPhotosView *photosView;
/** 时间 */
@property (strong,nonatomic) UILabel *timeLabel;

@end

@implementation PlaceDiscussTableCell

+ (instancetype)sharedDiscussCell:(UITableView *)tableView
{
    static NSString *ID = @"PlaceDiscussTableCell";
    PlaceDiscussTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[PlaceDiscussTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}

- (void)setDiscussModel:(PlaceDiscussModel *)discussModel
{
    _discussModel = discussModel;
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:discussModel.creater_head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    _nameLabel.text = discussModel.creater_name;
    _contentLabel.text = discussModel.discuss_content;
    _timeLabel.text = discussModel.create_time;
    if (discussModel.scenic_img_desc.count >= 1) {
        // 有图
        _photosView.hidden = NO;
        _photosView.thumbnailUrls = self.discussModel.scenic_img_desc;
        if (discussModel.scenic_img_desc.count > 0 && discussModel.scenic_img_desc.count < 4){
            // 1-3张图
            [_photosView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentLabel.mas_left);
                make.top.equalTo(self.contentLabel.mas_bottom).offset(8);
                make.width.equalTo(@(PYPhotoMargin * 4 + PYPhotoWidth * 3));
                make.height.equalTo(@(PYPhotoMargin * 2 + PYPhotoHeight * 1));
            }];
        }else if (discussModel.scenic_img_desc.count >= 4 && discussModel.scenic_img_desc.count < 7){
            // 4-6张图
            [_photosView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentLabel.mas_left);
                make.top.equalTo(self.contentLabel.mas_bottom).offset(8);
                make.width.equalTo(@(PYPhotoMargin * 4 + PYPhotoWidth * 3));
                make.height.equalTo(@(PYPhotoMargin * 3 + PYPhotoHeight * 2));
            }];
        }else{
            // 7-9张图
            [_photosView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentLabel.mas_left);
                make.top.equalTo(self.contentLabel.mas_bottom).offset(8);
                make.width.equalTo(@(PYPhotoMargin * 4 + PYPhotoWidth * 3));
                make.height.equalTo(@(PYPhotoMargin * 4 + PYPhotoHeight * 3));
            }];
        }
        
    }else{
        // 无图
        self.photosView.hidden = YES;
    }
}
- (void)setupSubViews
{
    // 头像
    self.headImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_place"]];
    self.headImgView.userInteractionEnabled = YES;
    self.headImgView.frame = CGRectMake(15, 10, 36, 36);
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.headImgView setContentScaleFactor:[UIScreen mainScreen].scale];
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight & UIViewAutoresizingFlexibleWidth;
    self.headImgView.layer.cornerRadius = 18;
    [self.contentView addSubview:self.headImgView];
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.ClickUserBlock) {
            _ClickUserBlock(self.discussModel.creater_id);
        }
    }];
    [self.headImgView addGestureRecognizer:headTap];
    
    
    
    // 名称
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImgView.frame) + 10, self.headImgView.y + 2, 200, 20)];
    self.nameLabel.text = @"林中鹿";
    self.nameLabel.userInteractionEnabled = YES;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
    self.nameLabel.textColor = RGBACOLOR(151, 171, 209, 1);
    [self.contentView addSubview:self.nameLabel];
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.ClickUserBlock) {
            _ClickUserBlock(self.discussModel.creater_id);
        }
    }];
    [self.nameLabel addGestureRecognizer:nameTap];
    
    // 评论的文字
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.textColor = RGBACOLOR(87, 87, 87, 1);
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.text = @"马卡卡玛卡没卡么卡卡没课吗看看嘛卡马克，蛇口蛇口马上开始科目是。请救救我鸡尾酒那我就借钱交加QQ。";
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-30);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
    }];
    
    // 附图
    self.photosView = [PYPhotosView photosView];
    _photosView.showDuration = 0.25;
    _photosView.hiddenDuration = 0.25;
    _photosView.photoMargin = 1.5;
    [self.contentView addSubview:self.photosView];
    [self.photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel.mas_left);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(8);
        make.width.equalTo(@(PYPhotoMargin * 2 + PYPhotoWidth * 3));
        make.height.equalTo(@(PYPhotoMargin * 2 + PYPhotoHeight * 3));
    }];
    
    // 时间
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.text = @"08:23";
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.height.equalTo(@20);
    }];

}

@end
