//
//  DrawCircleView.m
//  FYQ
//
//  Created by Chan_Sir on 2017/3/2.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "DrawCircleView.h"

@implementation DrawCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HWRandomColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawPathUseRed:233 green:67 blue:87 andStartAngle:0 endAngle:2*M_PI];
    
}

- (CAShapeLayer *)drawPathUseRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b andStartAngle:(CGFloat)start endAngle:(CGFloat)end {
    //    UIBezierPath * path;
    
    CGPoint center = CGPointMake(self.width/2, 150);
    CGFloat lineWidth = 30.f;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:center radius:120*CKproportion startAngle:start endAngle:end clockwise:YES];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor =  RGBACOLOR(r, g, b,  1).CGColor;
    layer.lineWidth = lineWidth;
    
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = 0.8;
    //    bas.delegate = self;
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
    
    [self.layer addSublayer:layer];
    
    return layer;
}



@end
