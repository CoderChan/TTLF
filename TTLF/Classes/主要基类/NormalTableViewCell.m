//
//  NormalTableViewCell.m
//  FYQ
//
//  Created by Chan_Sir on 2016/11/25.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "NormalTableViewCell.h"
#import <Masonry.h>

@implementation NormalTableViewCell

+ (instancetype)sharedNormalCell:(UITableView *)tableView
{
    static NSString *ID = @"NormalTableViewCell";
    NormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NormalTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        self.backgroundColor = [UIColor whiteColor];
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
        make.width.and.height.equalTo(@36);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.titleLabel.textColor = TitleColor;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconView.mas_centerY);
        make.left.equalTo(self.iconView.mas_right).offset(12);
        make.height.equalTo(@23);
    }];
    
    
    
//#备注：一次加载5天内的内容
//    
//    "code" : 1
//    "message" : @"新闻列表"
//    "result" : @[
//                 
//                 @{"date" : @"2017年8月24日 08:32"
//                   "news" : @[
//                           文章1
//                           文章2
//                           ············
//                           ]
//                   },
//                 
//                 @{"date" : @"2017年8月23日 08:32"
//                   "news" : @[
//                           文章1
//                            文章2
//                             ···········
//                             ]
//                   }
//                  ·············
//                 
//                 ]
//    
//    
    
    
}



@end
