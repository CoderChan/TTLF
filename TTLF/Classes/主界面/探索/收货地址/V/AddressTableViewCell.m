//
//  AddressTableViewCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AddressTableViewCell.h"
#import <Masonry.h>

@interface AddressTableViewCell ()

/** 收货人名字 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 电话号码 */
@property (strong,nonatomic) UILabel *phoneLabel;
/** 详细地址 */
@property (strong,nonatomic) UILabel *addressLabel;
/** 是否为默认地址 */
@property (strong,nonatomic) UIButton *defaultBtn;


@end

@implementation AddressTableViewCell

+ (instancetype)sharedAddressCell:(UITableView *)tableView
{
    static NSString *ID = @"AddressTableViewCell";
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[AddressTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    // 收货人
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.text = @"沙瑞金";
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.height.equalTo(@21);
    }];
    
    // 电话
    self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.phoneLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.phoneLabel.textAlignment = NSTextAlignmentRight;
    self.phoneLabel.text = @"13628392811";
    [self.contentView addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.height.equalTo(@21);
    }];
    
    // 详细地址
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.addressLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.addressLabel.numberOfLines = 2;
    self.addressLabel.text = @"北京市大兴区天宫院地铁B出口保利春天里8号楼一单元504室OSOSOSOSOSOSOOSOSOSOSSO";
    [self.contentView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.equalTo(@42);
    }];
    
    // 线
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xuxian"]];
    [self.contentView addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(6);
        make.height.equalTo(@2);
    }];
    
    // 设为默认地址
    self.defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.defaultBtn setImage:[UIImage imageNamed:@"cm2_list_checkbox"] forState:UIControlStateNormal];
    self.defaultBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.defaultBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [self.defaultBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.defaultBtn setTitle:@"设为默认地址" forState:UIControlStateNormal];
    [self.defaultBtn addTarget:self action:@selector(didSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.defaultBtn];
    [self.defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xian.mas_bottom).offset(6);
        make.width.equalTo(@130);
        make.height.equalTo(@30);
        make.left.equalTo(@12);
    }];
    
    
}

- (void)didSelected:(UIButton *)sender
{
    [sender setImage:[UIImage imageNamed:@"cm2_list_checkbox_ok"] forState:UIControlStateNormal];
}


@end
