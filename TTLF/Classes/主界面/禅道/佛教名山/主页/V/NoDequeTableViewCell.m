//
//  NoDequeTableViewCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/14.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "NoDequeTableViewCell.h"

@implementation NoDequeTableViewCell

+ (instancetype)sharedCell:(UITableView *)tableView
{
    static NSString *ID = @"NoDequeTableViewCell";
    NoDequeTableViewCell *cell = [[NoDequeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
}

@end
