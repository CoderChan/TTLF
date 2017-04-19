//
//  DecorationListView.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/23.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,DecorationType) {
    FlowerType = 1,  // 花瓶饰品
    XiangType = 2,   // 贡香饰品
    FruitType = 3,   // 水果饰品
};

@protocol DecorationListViewDelegate <NSObject>

- (void)decorationListViewWithType:(DecorationType)decorationType SelectModel:(id)selectModel;

@end

@interface DecorationListView : UIView

/** 哪一种饰品类型 */
@property (assign,nonatomic) DecorationType decorationType;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 代理回调方法 */
@property (weak,nonatomic) id<DecorationListViewDelegate> delegate;


@end
