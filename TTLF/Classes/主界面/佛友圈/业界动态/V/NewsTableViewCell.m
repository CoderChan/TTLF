//
//  NewsTableViewCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/6.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "NewsTableViewCell.h"
#import <Masonry.h>



@interface NewsTableViewCell ()

/** 文章封面 */
@property (strong,nonatomic) UIImageView *newsImgView;
/** 标题 */
@property (strong,nonatomic) UILabel *titleLabel;
/** 来源 */
@property (strong,nonatomic) UILabel *fromLabel;
/** 时间 */
@property (strong,nonatomic) UILabel *timeLabel;

@end

@implementation NewsTableViewCell

+ (instancetype)sharedNewsCell:(UITableView *)tableView
{
    static NSString *ID = @"NewsTableViewCell";
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[NewsTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(NewsArticleModel *)model
{
    _model = model;
    [_newsImgView sd_setImageWithURL:[NSURL URLWithString:model.news_logo] placeholderImage:[UIImage imageNamed:@"error_place"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            _newsImgView.image = [image stretchableImageWithLeftCapWidth:20 topCapHeight:10];
        }
    }];
    _titleLabel.text = model.news_name;
    _fromLabel.text = [NSString stringWithFormat:@"#%@#",model.keywords];
    
    NSString *dateStr = [model.createtime substringWithRange:NSMakeRange(5, 6)];
    _timeLabel.text = dateStr;
}

- (void)setupSubViews
{
    // 封面
    self.newsImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"error_place"]];
    self.newsImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.newsImgView setContentScaleFactor:[UIScreen mainScreen].scale];
    self.newsImgView.layer.masksToBounds = YES;
    self.newsImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight & UIViewAutoresizingFlexibleWidth;
    self.newsImgView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.newsImgView];
    [self.newsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@98);
        make.height.equalTo(@78);
    }];
    
    // 文章标题
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"四川佛像的这根衣带 系出来一条中原佛像史";
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.newsImgView.mas_right).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.equalTo(@50);
        make.top.equalTo(self.newsImgView.mas_top).offset(1);
    }];
    
    // 来源
    self.fromLabel = [[UILabel alloc]init];
    self.fromLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.fromLabel.textColor = RGBACOLOR(108, 108, 108, 1);
    self.fromLabel.text = @"凤凰佛教";
    [self.contentView addSubview:self.fromLabel];
    [self.fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.bottom.equalTo(self.newsImgView.mas_bottom).offset(2);
        make.height.equalTo(@21);
    }];
    
    // 时间
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel.mas_right);
        make.centerY.equalTo(self.fromLabel.mas_centerY);
        make.height.equalTo(@21);
    }];
    
    // 线
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    [self.contentView addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(1);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@2);
    }];
    
}

@end
