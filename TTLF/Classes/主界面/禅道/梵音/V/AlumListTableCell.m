//
//  AlumListTableCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/6/19.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AlumListTableCell.h"


@interface AlumListTableCell ()

// 序号
@property (strong,nonatomic) UILabel *orderLabel;
// 名称


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

- (void)setupSubViews
{
    
}

@end
