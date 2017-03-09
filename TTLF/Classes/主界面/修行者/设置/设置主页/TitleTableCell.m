//
//  TitleTableCell.m
//  FYQ
//
//  Created by Chan_Sir on 2017/1/7.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "TitleTableCell.h"
#import <Masonry.h>


@implementation TitleTableCell

+ (instancetype)sharedTitleTableCell:(UITableView *)tableView
{
    static NSString *ID = @"TitleCell";
    TitleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TitleTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
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
    self.label = [[UILabel alloc]init];
    self.label.text = @"退出当前账号";
    self.label.textColor = [UIColor blackColor];
    self.label.alpha = 1;
    self.label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@22);
    }];
}

@end
