//
//  PlayingRightBarView.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/2.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingRightBarView : UIView

@property (copy,nonatomic) void (^ClickBlock)();

// - (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
