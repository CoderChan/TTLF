//
//  PunnaListTableCell.m
//  FYQ
//
//  Created by Chan_Sir on 2017/3/10.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PunnaListTableCell.h"
#import <Masonry.h>


@interface PunnaListTableCell ()

@property (strong,nonatomic) UIImageView *iconView;

@property (strong,nonatomic) UILabel *contentLabel;

@property (strong,nonatomic) UILabel *timeLabel;

@property (strong,nonatomic) UILabel *valueLabel;

@end

@implementation PunnaListTableCell

+ (instancetype)sharedPunnaListTableCell:(UITableView *)tableView
{
    static NSString *ID = @"PunnaListTableCell";
    PunnaListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[PunnaListTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupSubViews];
    }
    return self;
}
- (void)setModel:(PunaNumListModel *)model
{
    _model = model;
    _valueLabel.text = model.option_value;
    if ([model.option_type containsString:@"发动态"]) {
        _iconView.image = [UIImage imageNamed:@"punna_send_tips"];
        _contentLabel.text = @"日行动态轨迹";
    }else if([model.option_type containsString:@"礼佛一天"]){
        _iconView.image = [UIImage imageNamed:@"puna_lifo_icon"];
        _contentLabel.text = @"天天礼佛";
    }else{
        _contentLabel.text = model.option_type;
    }
    
    NSDate *dateStr = [NSDate dateWithTimeIntervalSince1970:model.create_time];
    NSInteger hour = dateStr.hour;
    NSString *hourStr = [NSString stringWithFormat:@"%ld",hour];
    if (hourStr.length == 1) {
        if (hour <= 5) {
            hourStr = [NSString stringWithFormat:@"凌晨 0%@",hourStr];
        }else if(hour >= 9){
            hourStr = [NSString stringWithFormat:@"上午 0%@",hourStr];
        }else{
            hourStr = [NSString stringWithFormat:@"清晨 0%@",hourStr];
        }
    }
    
    NSInteger minite = dateStr.minute;
    NSString *miniteStr = [NSString stringWithFormat:@"%ld",minite];
    if (miniteStr.length == 1) {
        miniteStr = [NSString stringWithFormat:@"0%@",miniteStr];
    }
    NSString *hourMinite = [NSString stringWithFormat:@"%@:%@",hourStr,miniteStr];
    
    NSString *date;
    if ([dateStr isToday]) {
        date = @"今天";
    }else if([dateStr isYesterday]){
        date = @"昨天";
    }else{
        date = [NSString stringWithFormat:@"%ld日",dateStr.day];
    }
    _timeLabel.text = [NSString stringWithFormat:@"%@ %@",date,hourMinite];
    
    
}


- (void)setupSubViews
{
    self.iconView = [[UIImageView alloc]initWithImage:[UIImage imageWithColor:HWRandomColor]];
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = 20;
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.and.height.equalTo(@40);
    }];
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(12);
        make.bottom.equalTo(self.iconView.mas_centerY);
        make.height.equalTo(@25);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textColor = [UIColor grayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel.mas_left);
        make.top.equalTo(self.contentLabel.mas_bottom);
        make.height.equalTo(@21);
    }];
    
    self.valueLabel = [[UILabel alloc]init];
    self.valueLabel.font = [UIFont boldSystemFontOfSize:25];
    self.valueLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.valueLabel];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@30);
    }];
    
    
}

@end
