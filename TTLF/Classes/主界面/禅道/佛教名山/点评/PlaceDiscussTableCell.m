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
    
    
    // 名称
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImgView.frame) + 10, self.headImgView.y + 2, 200, 20)];
    self.nameLabel.text = @"林中鹿";
    self.nameLabel.userInteractionEnabled = YES;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
    self.nameLabel.textColor = RGBACOLOR(151, 171, 209, 1);
    [self.contentView addSubview:self.nameLabel];
    
    
    // 评论的文字
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.textColor = RGBACOLOR(87, 87, 87, 1);
    self.contentLabel.font = [UIFont systemFontOfSize:14];
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
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        [array addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1494848326469&di=ddd17854689a103f2858afc1e7adf1f0&imgtype=0&src=http%3A%2F%2Fwww.rmzt.com%2Fuploads%2Fallimg%2F151013%2F1-15101315314H15.jpg"];
    }
    self.photosView.thumbnailUrls = array;
    [self.contentView addSubview:self.photosView];
    [self.photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel.mas_left);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(8);
        make.width.equalTo(@(_photosView.photoMargin * 2 + _photosView.photoWidth * 3));
        make.height.equalTo(@(_photosView.photoMargin * 2 + _photosView.photoWidth * 3));
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
