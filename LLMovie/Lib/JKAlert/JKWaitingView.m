//
//  JKWaitingView.m
//  AlertAssemble
//
//  Created by 四威 on 2016/8/3.
//  Copyright © 2016年 JeanKyle. All rights reserved.
//

#import "JKWaitingView.h"
#import "UIView+JKAlert.h"

@interface JKWaitingView (){
    CAShapeLayer *layer;
    CGFloat angle;
}
@end

@implementation JKWaitingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        angle = 1;
        [self drawRound];
    }
    return self;
}
- (void)drawRound {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(half(self.jk_width), half(self.jk_height)) radius:half(self.jk_width) * 0.7 startAngle:0 endAngle:angleMake(-320) clockwise:NO];
    layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.lineWidth = LINE_WIDTH;
    layer.frame = self.bounds;
    [self.layer addSublayer:layer];
    [self drawLineAnimation];
}


- (void)drawLineAnimation{
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.fromValue = [NSNumber numberWithInteger:1];
    bas.toValue = [NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
    [self startAnimation];
}
- (void)startAnimation {
    [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(translateAnimation) userInfo:nil repeats:YES];
}

- (void)translateAnimation {
    angle += 10;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.02];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    self.transform = CGAffineTransformMakeRotation(angleMake(angle));
    [UIView commitAnimations];
}
@end
