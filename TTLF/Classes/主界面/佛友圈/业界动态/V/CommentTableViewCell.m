//
//  CommentTableViewCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "CommentTableViewCell.h"
#import <Masonry.h>
#import "XLPhotoBrowser.h"


@interface CommentTableViewCell ()

/** 头像 */
@property (strong,nonatomic) UIImageView *headImgView;
/** 昵称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 内容 */
@property (strong,nonatomic) UILabel *contentLabel;
/** 附图 */
@property (strong,nonatomic) UIImageView *insertImgView;
/** 时间 */
@property (strong,nonatomic) UILabel *timeLabel;

@end

@implementation CommentTableViewCell

+ (instancetype)sharedCommentTableCell:(UITableView *)tableView
{
    
    static NSString *ID = @"CommentTableViewCell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
    
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

- (void)setCommentModel:(NewsCommentModel *)commentModel
{
    _commentModel = commentModel;
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:commentModel.commenter_head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    _nameLabel.text = commentModel.commenter_name;
    _contentLabel.text = commentModel.comment_text;
    if (commentModel.comment_pic.length > 5) {
        _insertImgView.hidden = NO;
        [_insertImgView sd_setImageWithURL:[NSURL URLWithString:commentModel.comment_pic] placeholderImage:[UIImage imageNamed:@"image_place"]];
    }else{
        _insertImgView.hidden = YES;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:commentModel.comment_time];
    NSString *dateStr = [date formattedDateDescription];
    if (dateStr.length >= 10) {
        _timeLabel.text = [dateStr substringWithRange:NSMakeRange(0, 10)];
    }else{
        _timeLabel.text = dateStr;
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
        if (self.UserClickBlock) {
            _UserClickBlock(_commentModel);
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
        if (self.UserClickBlock) {
            _UserClickBlock(_commentModel);
        }
    }];
    [self.nameLabel addGestureRecognizer:nameTap];
    
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
    self.insertImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image_place"]];
    self.insertImgView.userInteractionEnabled = YES;
    self.insertImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.insertImgView setContentScaleFactor:[UIScreen mainScreen].scale];
    self.insertImgView.layer.masksToBounds = YES;
    self.insertImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.insertImgView];
    [self.insertImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
        make.left.equalTo(self.contentLabel.mas_left);
        make.width.equalTo(@70);
        make.height.equalTo(@60);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [XLPhotoBrowser showPhotoBrowserWithImages:@[_commentModel.comment_pic] currentImageIndex:0];
    }];
    [self.insertImgView addGestureRecognizer:tap];
    
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
