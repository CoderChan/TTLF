//
//  NewFetherViewController.m
//  YLRM
//
//  Created by Chan_Sir on 16/9/1.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "NewFetherViewController.h"



@interface NewFetherViewController ()



@end

@implementation NewFetherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (SCREEN_WIDTH == 375) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"laugh_ip6"]];
    }else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"laugh"]];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    animation.subtype = kCATransitionFromBottom;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
