//
//  SendDynTableCell.m
//  FYQ
//
//  Created by Chan_Sir on 2017/3/1.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SendDynTableCell.h"
#import <Masonry.h>

@implementation SendDynTableCell

+ (instancetype)sharedSendDynTableCell:(UITableView *)tableView
{
    static NSString *ID = @"SendDynTableCell";
    SendDynTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SendDynTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self setupSubViews];
    }
    return self;
}



- (void)setupSubViews
{
    self.iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_place"]];
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.and.height.equalTo(@35);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.titleLabel.textColor = TitleColor;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconView.mas_centerY);
        make.left.equalTo(self.iconView.mas_right).offset(10);
        make.height.equalTo(@23);
    }];
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    self.contentLabel.textColor = TitleColor;
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconView.mas_centerY);
        make.left.equalTo(self.titleLabel.mas_right).offset(30);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@21);
    }];
    
}



@end
