//
//  PunaListHeadView.h
//  FYQ
//
//  Created by Chan_Sir on 2017/3/10.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PunaListHeadView : UIView

/** 年月 */
@property (copy,nonatomic) NSString *yearMonth;
/** 总计 */
@property (copy,nonatomic) NSString *sumPunaNum;
/** 点击弹出月份 */
@property (copy,nonatomic) void (^ClickBlock)();

@end
