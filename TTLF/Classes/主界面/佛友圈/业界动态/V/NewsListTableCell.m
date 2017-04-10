//
//  NewsListTableCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/10.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "NewsListTableCell.h"
#import <Masonry.h>

@interface NewsListTableCell ()

/** 封面、修饰图 */
@property (strong,nonatomic) UIImageView *iconImgView;
/** 文章标题 */
@property (strong,nonatomic) UILabel *titleLabel;

@end

@implementation NewsListTableCell

+ (instancetype)sharedNewsListTableCell:(UITableView *)tableView
{
    static NSString *ID = @"NewsListTableCell";
    NewsListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[NewsListTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setModel:(NewsArticleModel *)model
{
    _model = model;
    if (model.isNewest) {
        // 显示文章封面
        [_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:[UIImage imageWithColor:HWRandomColor]];
        _titleLabel.numberOfLines = 2;
        _titleLabel.text = model.title;
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImgView.mas_right).offset(8);
            make.height.equalTo(@44);
            make.right.equalTo(self.contentView.mas_right).offset(-8);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }else{
        // 显示点修饰
        _titleLabel.text = model.title;
        _titleLabel.numberOfLines = 1;
        _iconImgView.image = [UIImage imageNamed:@"news_point"];
        [_iconImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(14);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.and.height.equalTo(@6);
        }];
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@21);
            make.left.equalTo(self.iconImgView.mas_right).offset(8);
            make.right.equalTo(self.contentView.mas_right).offset(-8);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    self.iconImgView = [[UIImageView alloc]init];
    self.iconImgView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconImgView];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@56);
        make.height.equalTo(@52);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-8);
        make.top.equalTo(self.mas_top).offset(5);
        make.height.equalTo(@21);
    }];
}

@end
