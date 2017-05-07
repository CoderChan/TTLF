//
//  MyVageTableViewCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/7.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MyVageTableViewCell.h"

@implementation MyVageTableViewCell

+ (instancetype)shardMyVageCell:(UITableView *)tableView
{
    static NSString *ID = @"MyVageTableViewCell";
    MyVageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MyVageTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.accessoryType = UITableViewCellAccessoryNone;
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews
{
    
}

@end
