//
//  NewsHeadView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/4.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "NewsHeadView.h"
#import <Masonry.h>
#import "NewsListTableCell.h"


@interface NewsHeadView ()<UITableViewDelegate,UITableViewDataSource>

/** 个人头像 */
@property (strong,nonatomic) UIImageView *headImgView;
/** 我的名字 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 功德值 */
@property (strong,nonatomic) UILabel *gongdeLabel;
/** xxx，已为您定制了业界头条 */
@property (strong,nonatomic) UILabel *label;

@property (strong,nonatomic) UITableView *newsTableView;
@property (copy,nonatomic) NSArray *array;

@end


@implementation NewsHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self layoutSubviewsssss];
    }
    return self;
}

- (void)setUserModel:(UserInfoModel *)userModel
{
    _userModel = userModel;
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:userModel.headUrl] placeholderImage:[UIImage imageNamed:@"user_place"]];
    _nameLabel.text = userModel.nickName;
    
    _label.text = [NSString stringWithFormat:@"%@，为您定制了头条",userModel.nickName];
    
    NSString *tempStr = [NSString stringWithFormat:@"功德值 %@",self.userModel.punnaNum];
    NSRange range = [tempStr rangeOfString:self.userModel.punnaNum];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:tempStr];
    [attributeStr beginEditing];
    [attributeStr addAttributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote],NSForegroundColorAttributeName:[UIColor whiteColor]} range:range];
    _gongdeLabel.attributedText = attributeStr;
}

- (void)layoutSubviewsssss
{
//    [super layoutSubviews];
    
    // 240
    // 1、个人信息的底部视图
    UIView *userView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height * 0.33)];
    userView.userInteractionEnabled = YES;
    userView.backgroundColor = NavColor;
    [self addSubview:userView];
    
    // 我的头像
    self.headImgView = [[UIImageView alloc]init];
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.userModel.headUrl] placeholderImage:[UIImage imageNamed:@"user_place"]];
    self.headImgView.userInteractionEnabled = YES;
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = 20;
    [userView addSubview:self.headImgView];
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userView.mas_top).offset(16);
        make.left.equalTo(userView.mas_left).offset(15);
        make.width.and.height.equalTo(@40);
    }];
    
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.ClickBlock) {
            _ClickBlock(HeadUserClickType);
        }
    }];
    [self.headImgView addGestureRecognizer:headTap];
    
    // 我的名称
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = self.userModel.nickName;
    self.nameLabel.userInteractionEnabled = YES;
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
    [userView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headImgView.mas_centerY);
        make.left.equalTo(self.headImgView.mas_right).offset(12);
        make.height.equalTo(@24);
    }];
    
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.ClickBlock) {
            _ClickBlock(HeadUserClickType);
        }
    }];
    [self.nameLabel addGestureRecognizer:nameTap];
    
    // 右边功德值
    UIView *gongdeView = [[UIView alloc]initWithFrame:CGRectZero];
    gongdeView.userInteractionEnabled = YES;
    gongdeView.backgroundColor = RGBACOLOR(50, 107, 80, 1);
    gongdeView.layer.masksToBounds = YES;
    gongdeView.layer.cornerRadius = 20;
    gongdeView.layer.shadowColor = [UIColor purpleColor].CGColor;
    gongdeView.layer.shadowOpacity = 0.8f;
    gongdeView.layer.shadowRadius = 4.f;
    gongdeView.layer.shadowOffset = CGSizeMake(2, 2);
    [userView addSubview:gongdeView];
    [gongdeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(userView.mas_right);
        make.width.equalTo(@180);
        make.centerY.equalTo(self.headImgView.mas_centerY);
        make.height.equalTo(@40);
    }];
    
    UITapGestureRecognizer *gongdeTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.ClickBlock) {
            _ClickBlock(HeadGongdeClickType);
        }
    }];
    [gongdeView addGestureRecognizer:gongdeTap];
    
    // 功德值
    self.gongdeLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 5, 100 - 2, 30)];
    self.gongdeLabel.textAlignment = NSTextAlignmentCenter;
    self.gongdeLabel.text = [NSString stringWithFormat:@"功德值 %@",self.userModel.punnaNum];
    self.gongdeLabel.textColor = [UIColor whiteColor];
    self.gongdeLabel.font = [UIFont systemFontOfSize:10];
    [gongdeView addSubview:self.gongdeLabel];
    
    
    // 2、新闻节目
    UIView *newsView = [[UIView alloc]initWithFrame:CGRectMake(20, self.height * 0.24, self.width - 40, self.height * 0.76 - 15)];
    newsView.backgroundColor = [UIColor whiteColor];
    newsView.userInteractionEnabled = YES;
    newsView.layer.shadowColor = [UIColor blackColor].CGColor;
    newsView.layer.shadowOpacity = 0.8f;
    newsView.layer.shadowRadius = 4.f;
    newsView.layer.shadowOffset = CGSizeMake(0, 0);
    [self addSubview:newsView];
    
    UITapGestureRecognizer *newsTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.ClickBlock) {
            _ClickBlock(HeadNewsClickType);
        }
    }];
    [newsView addGestureRecognizer:newsTap];
    
    // xxx，定制了头条
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 4, newsView.width, 30)];
    self.label.text = [NSString stringWithFormat:@"%@，为您定制了头条",self.userModel.nickName];
    self.label.font = [UIFont boldSystemFontOfSize:14];
    self.label.textAlignment = NSTextAlignmentCenter;
    [newsView addSubview:self.label];
    
    // 线1
//    UIImageView *xian1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
//    xian1.frame = CGRectMake(15, 38, newsView.width - 30, 2);
//    [newsView addSubview:xian1];
    
    self.newsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, newsView.width, newsView.height - 32)];
    self.newsTableView.backgroundColor = self.backgroundColor;
    self.newsTableView.scrollEnabled = NO;
    self.newsTableView.showsVerticalScrollIndicator = NO;
    self.newsTableView.showsHorizontalScrollIndicator = NO;
    self.newsTableView.delegate = self;
    self.newsTableView.dataSource = self;
    [newsView addSubview:self.newsTableView];
    
    
    // 线3
    UIImageView *xian3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    [self addSubview:xian3];
    [xian3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NewsArticleModel *model = [[NewsArticleModel alloc]init];
        model.isNewest = YES;
        model.title = @"中泰两国佛教领袖相聚曼谷，一脉相承共创未来";
        model.coverUrl = @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2056808312,2400449481&fm=23&gp=0.jpg";
        NewsListTableCell *cell = [NewsListTableCell sharedNewsListTableCell:tableView];
        cell.model = model;
        return cell;
    }else{
        NewsArticleModel *model = [[NewsArticleModel alloc]init];
        model.isNewest = NO;
        model.title = @"中泰两国佛教领袖相聚曼谷，一脉相承共创未来";
        NewsListTableCell *cell = [NewsListTableCell sharedNewsListTableCell:tableView];
        cell.model = model;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 70;
    }else{
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    xian.frame = CGRectMake(0, 6, tableView.width, 1);
    [footView addSubview:xian];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 13, tableView.width, 21)];
    label.text = @"查看更多";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor grayColor];
    [footView addSubview:label];
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

@end
