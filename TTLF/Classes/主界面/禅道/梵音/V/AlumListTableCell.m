//
//  AlumListTableCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/6/19.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AlumListTableCell.h"


@interface AlumListTableCell ()



@end

@implementation AlumListTableCell

+ (instancetype)sharedAlumCell:(UITableView *)tableView
{
    static NSString *ID = @"AlumListTableCell";
    AlumListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[AlumListTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(AlbumInfoModel *)model
{
    _model = model;
    _nameLabel.text = model.music_name;
    _orderLabel.text = [NSString stringWithFormat:@"%ld",(long)model.index];
}

- (void)setupSubViews
{
    // 序号
    self.orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 30, 30)];
    self.orderLabel.font = [UIFont systemFontOfSize:15];
    self.orderLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.orderLabel];
    
    // 名称
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(48, 15, SCREEN_WIDTH - 50 - 50, 30)];
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self.contentView addSubview:self.nameLabel];
    
    // 按钮
//    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.button setImage:[UIImage imageNamed:@"music_more"] forState:UIControlStateNormal];
//    [self.button setImage:[UIImage imageNamed:@"music_more"] forState:UIControlStateHighlighted];
//    [self.button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//        
//    }];
//    self.button.frame = CGRectMake(SCREEN_WIDTH - 15 - 30, 15, 30, 30);
//    [self.contentView addSubview:self.button];
    
}

@end
