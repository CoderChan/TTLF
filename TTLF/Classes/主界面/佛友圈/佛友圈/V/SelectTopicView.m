//
//  SelectTopicView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SelectTopicView.h"


@implementation SelectTopicView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CoverColor;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

@end
