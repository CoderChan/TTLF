//
//  ContentTableViewCell.m
//  FYQ
//
//  Created by Chan_Sir on 2017/1/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "ContentTableViewCell.h"
#import <Masonry.h>

@implementation ContentTableViewCell

+ (instancetype)sharedContentTableCell:(UITableView *)tableView
{
    static NSString *ID = @"ContentTableViewCell";
    ContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ContentTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel.textColor = TitleColor;
        self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.contentLabel.text = @"西红柿";
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = [UIColor grayColor];
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-28);
        make.height.equalTo(@21);
    }];
}

@end
