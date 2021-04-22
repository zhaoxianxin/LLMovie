//
//  JKInformView.m
//  AlertAssemble
//
//  Created by 四威 on 2016/8/1.
//  Copyright © 2016年 JeanKyle. All rights reserved.
//

#import "JKInformView.h"


@interface JKInformView () {
    CAShapeLayer *layer;
}

@property (nonatomic, assign) JKInformStyle stylePrivate;

@end

@implementation JKInformView

- (instancetype)initWithFrame:(CGRect)frame style:(JKInformStyle)style {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        _stylePrivate = style;
        [self drawRound];
    }
    return self;
}

- (void)drawRound {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(half(self.jk_width), half(self.jk_height)) radius:half(self.jk_width) startAngle:0 endAngle:2 * M_PI clockwise:NO];
    layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.lineWidth = LINE_WIDTH;
    layer.frame = self.bounds;
    [self.layer addSublayer:layer];
    [self drawLineAnimation];
    SEL drawAction;
    switch (_stylePrivate) {
        case JKInformStyleTick:
            drawAction = @selector(drawInformTick);
            break;
        case JKInformStyleCross:
            drawAction = @selector(drawInfromCross);
            break;
    }
    [self performSelector:drawAction withObject:nil afterDelay:ANIMATE_DURATION];
}

- (void)drawInformTick {
    double cl = half(self.jk_height * sqrt(2.0));
    double scl = cl - half(self.jk_height);
    double cwh = scl / sqrt(2.0);
    CGFloat offset = self.jk_width * ONE_SEVENTH;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(cwh, cwh + 2 * offset, 0, 0)];
    [path addLineToPoint:CGPointMake(half(self.jk_width), half(self.jk_height) + 2 * offset)];
    [path addLineToPoint:CGPointMake(self.jk_width - cwh, cwh + offset)];
    layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.lineWidth = LINE_WIDTH;
    layer.frame = self.bounds;
    [self.layer addSublayer:layer];
    [self drawLineAnimation];
}

- (void)drawInfromCross {
    double cl = half(self.jk_height * sqrt(2.0));
    double scl = cl - half(self.jk_height);
    double cwh = scl / sqrt(2.0) + (self.jk_width * ONE_SEVENTH);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(cwh, cwh, 0, 0)];
    [path addLineToPoint:CGPointMake(self.jk_width - cwh, self.jk_height - cwh)];
    [path moveToPoint:CGPointMake(self.jk_width - cwh, cwh)];
    [path addLineToPoint:CGPointMake(cwh, self.jk_height - cwh)];
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
    bas.duration = ANIMATE_DURATION;
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}
@end
