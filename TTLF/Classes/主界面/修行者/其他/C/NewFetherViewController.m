//
//  NewFetherViewController.m
//  YLRM
//
//  Created by Chan_Sir on 16/9/1.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "NewFetherViewController.h"
#import "XLPhotoBrowser.h"
#import "RootTabbarController.h"
#import <Masonry.h>


@interface NewFetherViewController ()

@property (copy,nonatomic) NSArray *array;

@end

@implementation NewFetherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(17, 49, 73, 1);
    
    self.array = @[@"http://img.juimg.com/tuku/yulantu/120511/154264-12051121124423.jpg",@"http://pic.58pic.com/58pic/11/20/35/30858PIC3FS.jpg",@"http://pic1.win4000.com/wallpaper/5/54055707675cb.jpg",@"http://s3.sinaimg.cn/mw690/005U6MW0gy6QSZWi6Z4d2"];
    [self setupSubViews];
    
}
- (void)setupSubViews
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in self.array) {
        NSURL *url = [NSURL URLWithString:str];
        [array addObject:url];
    }
    
    // 创建不带标题的图片轮播器
    [XLPhotoBrowser showPhotoBrowserWithImages:array currentImageIndex:0];
    
    
    // 立即体验
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"立即跳过" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.6;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionFade;
        animation.subtype = kCATransitionFromBottom;
        [self.view.window.layer addAnimation:animation forKey:nil];
        
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
        
    }];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    button.backgroundColor = MainColor;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.bottom.equalTo(self.view.mas_bottom).offset(-35);
        make.height.equalTo(@42);
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in self.array) {
        NSURL *url = [NSURL URLWithString:str];
        [array addObject:url];
    }
    
    // 创建不带标题的图片轮播器
    [XLPhotoBrowser showPhotoBrowserWithImages:array currentImageIndex:0];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
