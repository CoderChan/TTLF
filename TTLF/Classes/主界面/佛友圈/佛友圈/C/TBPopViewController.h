//
//  TBPopViewController.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/20.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface TBPopViewController : SuperViewController

@property(nonatomic,strong) UIView * popView;

@property(nonatomic,strong) UIView * rootview;

@property(nonatomic,strong) UIViewController * rootVC;

@property(nonatomic,strong) UIView * maskView;

- (void)createPopVCWithRootVC:(UIViewController *)rootVC andPopView:(UIView *)popView;

@end
