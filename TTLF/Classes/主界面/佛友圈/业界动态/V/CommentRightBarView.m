//
//  CommentRightBarView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/18.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "CommentRightBarView.h"


@interface CommentRightBarView ()

@property (strong,nonatomic) UIImageView *bgImgView;

@property (strong,nonatomic) UILabel *commentLabel;

@end

@implementation CommentRightBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bgImgView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.bgImgView.image = [[UIImage imageNamed:@"comment_rightbar"] stretchableImageWithLeftCapWidth:2 topCapHeight:20];
    [self addSubview:self.bgImgView];
}

@end
