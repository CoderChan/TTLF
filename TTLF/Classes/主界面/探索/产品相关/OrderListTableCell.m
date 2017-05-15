//
//  OrderListTableCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "OrderListTableCell.h"
#import <Masonry.h>

@interface OrderListTableCell ()

/** 产品图标 */
@property (strong,nonatomic) UIImageView *goodImgView;
/** 标题 */
@property (strong,nonatomic) UILabel *nameLabel;

@end

@implementation OrderListTableCell

+ (instancetype)sharedOrderListCell:(UITableView *)tableView
{
    static NSString *ID = @"OrderListTableCell";
    OrderListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[OrderListTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
//    iPhone_place
    self.goodImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iPhone_place"]];
    [self.contentView addSubview:self.goodImgView];
    [self.goodImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.width.equalTo(@100);
    }];
    
    
}

@end
