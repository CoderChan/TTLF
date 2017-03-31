//
//  CommentHeadView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/30.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "CommentHeadView.h"
#import <Masonry.h>

@interface CommentHeadView ()



@end

@implementation CommentHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor purpleColor];
    
}

@end
