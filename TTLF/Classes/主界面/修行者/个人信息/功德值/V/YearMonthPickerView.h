//
//  YearMonthPickerView.h
//  FYQ
//
//  Created by Chan_Sir on 2017/3/10.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YearMonthPickerView : UIView

@property (copy,nonatomic) void (^SelectMonthBlock)(NSString *year,NSString *month);

@end
