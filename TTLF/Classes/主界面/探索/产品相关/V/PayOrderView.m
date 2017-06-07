//
//  PayOrderView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/26.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PayOrderView.h"
#import "NormalTableViewCell.h"

@interface PayOrderView ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *mengButton;
}
/** 空白处 */
@property (strong,nonatomic) UIView *bottomView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 商品的封面图 */
@property (strong,nonatomic) UIImageView *coverImgView;
/** 商品名称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 商品售价 */
@property (strong,nonatomic) UILabel *priceLabel;
/** 数量 */
@property (strong,nonatomic) UILabel *countLabel;
/** 地址选择 */
@property (strong,nonatomic) UILabel *addressLabel;


@end

@implementation PayOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CoverColor;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat BottomHeight = 380;
    // 蒙蒙按钮
    mengButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mengButton.frame = CGRectMake(0, 0, self.width, SCREEN_HEIGHT - BottomHeight);
    [mengButton addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mengButton];
    
    // 空白处
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(18, self.height - 18, self.width - 36, BottomHeight - 18)];
    self.bottomView.userInteractionEnabled = YES;
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.layer.cornerRadius = 8;
    self.bottomView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.bottomView.layer.shadowOffset = CGSizeMake(0,-3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.bottomView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    self.bottomView.layer.shadowRadius = 5;//阴影半径，默认3
    [self addSubview:self.bottomView];
    
    // 添加子控件
    [self addSubViewsAction];
    
    // 出现时的动画
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.y = self.height - BottomHeight;
    }];
    
}

#pragma mark - 添加子控件-表格相关
- (void)addSubViewsAction
{
    self.array = @[@"数  量",@"选择地址",@"支付总额"];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.bottomView.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.userInteractionEnabled = YES;
    self.tableView.backgroundColor = self.bottomView.backgroundColor;
    self.tableView.layer.cornerRadius = 8;
    self.tableView.rowHeight = 60;
    [self.bottomView addSubview:self.tableView];
    
    // 1、headView
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bottomView.width, 100)];
    headView.backgroundColor = self.bottomView.backgroundColor;
    headView.userInteractionEnabled = YES;
    
    // 商品封面
    self.coverImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 80, 80)];
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:self.goodsModel.article_logo] placeholderImage:[UIImage imageWithColor:HWRandomColor]];
    self.coverImgView.userInteractionEnabled = YES;
    self.coverImgView.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
    self.coverImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImgView.layer.masksToBounds = YES;
    self.coverImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.coverImgView.layer.borderWidth = 2;
    [headView addSubview:self.coverImgView];
    
    // 商品昵称
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.coverImgView.frame) + 6, self.coverImgView.y, headView.width - 100 - 6 - 20, 44)];
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.text = @"母亲节特惠，1.5厘米小叶紫檀";
    self.nameLabel.numberOfLines = 2;
    [headView addSubview:self.nameLabel];
    // 商品单价
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.x, 50, 200, 40)];
    self.priceLabel.text = @"￥599";
    self.priceLabel.font = [UIFont systemFontOfSize:16];
    self.priceLabel.textColor = WarningColor;
    NSMutableAttributedString *graytext = [[NSMutableAttributedString alloc] initWithString:self.priceLabel.text];
    [graytext beginEditing];
    NSRange range = NSMakeRange(1, self.priceLabel.text.length - 1);
    [graytext addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:24],NSForegroundColorAttributeName:WarningColor} range:range];
    self.priceLabel.attributedText =  graytext;
    [headView addSubview:self.priceLabel];
    
    // 线
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    xian.frame = CGRectMake(15, headView.height - 1, headView.width - 15, 2);
    [headView addSubview:xian];
    self.tableView.tableHeaderView = headView;
    
    
    // 2、footView
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bottomView.width, 70)];
    footView.backgroundColor = self.bottomView.backgroundColor;
    footView.userInteractionEnabled = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = MainColor;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    button.frame = CGRectMake(20, 20, footView.width - 40, 44);
    [button setTitle:@"确  定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [footView addSubview:button];
    
    self.tableView.tableFooterView = footView;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    [cell.titleLabel removeFromSuperview];
    [cell.iconView removeFromSuperview];
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [UIView new];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

#pragma mark - 消失
- (void)removeFromSuperview
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.y = self.height;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

@end
