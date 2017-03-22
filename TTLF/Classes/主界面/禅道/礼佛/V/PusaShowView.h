//
//  PusaShowView.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/21.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PusaShowViewDelegate <NSObject>

- (void)pusaDidSelect:(NSInteger)index;

@end

@interface PusaShowView : UIView


/** 代理 */
@property (nonatomic, weak) id<PusaShowViewDelegate> delegate;

/** 数据源 */
@property (copy,nonatomic) NSArray *array;

@end
