//
//  ImageTableViewCell.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/9.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "ImageTableViewCell.h"


@interface ImageTableViewCell ()

@property (strong,nonatomic) UIImageView *backImageView;

@end

@implementation ImageTableViewCell

+ (instancetype)sharedImageCell:(UITableView *)tableView
{
    static NSString *ID = @"ImageTableViewCell";
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ImageTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
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

- (void)setImage_url:(NSString *)image_url
{
    _image_url = [image_url description];
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:[UIImage imageWithColor:HWRandomColor]];
    
}

- (void)setupSubViews
{
    self.backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200*CKproportion)];
    self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.backImageView setContentScaleFactor:[UIScreen mainScreen].scale];
    self.backImageView.layer.masksToBounds = YES;
    self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight & UIViewAutoresizingFlexibleWidth;
    self.backImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backImageView.layer.borderWidth = 1;
    [self.contentView addSubview:self.backImageView];
    
}

@end
