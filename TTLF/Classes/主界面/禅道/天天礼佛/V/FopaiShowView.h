//
//  FopaiShowView.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/28.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FopaiViewDelegate <NSObject>

- (void)fopaiDidSelectFopaiModel:(FopaiModel *)fopaiModel;

@end

@interface FopaiShowView : UIView

/** 代理回调 */
@property (weak,nonatomic) id<FopaiViewDelegate> delegate;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;

@end
