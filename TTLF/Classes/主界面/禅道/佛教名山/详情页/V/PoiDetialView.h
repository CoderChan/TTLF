//
//  PoiDetialView.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/24.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

typedef NS_ENUM(NSInteger,ClickType) {
    CallPhoneType,
    ImageShowType,
};

@protocol PoiViewDelegate <NSObject>

- (void)poiViewWithType:(ClickType)type Model:(AMapPOI *)poiModel;

@end

@interface PoiDetialView : UIView

@property (strong,nonatomic) AMapPOI *poiModel;

@property (weak,nonatomic) id<PoiViewDelegate> delegate;

@end
