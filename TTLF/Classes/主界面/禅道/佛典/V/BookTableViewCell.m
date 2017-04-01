//
//  BookTableViewCell.m
//  BookStore
//
//  Created by Chan_Sir on 16/3/21.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "BookTableViewCell.h"
#import "Masonry.h"

@implementation BookTableViewCell

+ (instancetype)sharedBookTableViewCell:(UITableView *)tableView
{
    static NSString *ID = @"BookTableViewCell";
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BookTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BookShelfCell"]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupSubVies];
    }
    return self;
}

- (void)setupSubVies
{
    // gy_book_cell
    UIImageView *backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BookShelfCell"]];
    backImage.frame = self.bounds;
    [self addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    
}
@end
