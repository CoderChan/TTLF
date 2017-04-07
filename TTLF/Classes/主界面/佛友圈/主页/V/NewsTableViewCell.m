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

- (void)setupSubViews
{
    self.newsImgView = [[UIImageView alloc]initWithImage:[UIImage imageWithColor:HWRandomColor]];
    [self.contentView addSubview:self.newsImgView];
    [self.newsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@80);
        make.height.equalTo(@70);
    }];
    
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
    
    self.fromLabel = [[UILabel alloc]init];
    self.fromLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.fromLabel.textColor = RGBACOLOR(87, 87, 87, 1);
    self.fromLabel.text = @"凤凰佛教";
    [self.contentView addSubview:self.fromLabel];
    [self.fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.bottom.equalTo(self.newsImgView.mas_bottom);
        make.height.equalTo(@21);
    }];
    
    
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    [self.contentView addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@1);
    }];
    
}

@end
