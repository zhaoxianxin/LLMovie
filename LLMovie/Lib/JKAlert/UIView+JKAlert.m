//
//  UIView+JKAlert.m
//  AlertAssemble
//
//  Created by 四威 on 2016/7/28.
//  Copyright © 2016年 JeanKyle. All rights reserved.
//

#import "UIView+JKAlert.h"
#import "JKWaitingView.h"
#import "JKInformView.h"
#import "JKAdapterLabel.h"

CGFloat half(CGFloat number) {
    return number * 0.5;
}

CGFloat doubling(CGFloat number) {
    return number * 2.0;
}
CGFloat angleMake(CGFloat angle) {
    return angle * (M_PI / 180.0f);
}
CGFloat percent(CGFloat num) {
    return num / 100.0;
}
@implementation UIView (JKAlert)

#pragma mark - setter
- (void)setJk_x:(CGFloat)jk_x {
    CGRect frm = self.frame;
    frm.origin.x = jk_x;
    self.frame = frm;
}
- (void)setJk_y:(CGFloat)jk_y {
    CGRect frm = self.frame;
    frm.origin.y = jk_y;
    self.frame = frm;
}
- (void)setJk_width:(CGFloat)jk_width {
    CGRect frm = self.frame;
    frm.size.width = jk_width;
    self.frame = frm;
}
- (void)setJk_height:(CGFloat)jk_height {
    CGRect frm = self.frame;
    frm.size.height = jk_height;
    self.frame = frm;
}
- (void)setJk_size:(CGSize)jk_size {
    CGRect frm = self.frame;
    frm.size = jk_size;
    self.frame = frm;
}
#pragma mark - getter
- (CGFloat)jk_x {
    return self.frame.origin.x;
}
- (CGFloat)jk_y {
    return self.frame.origin.y;
}
- (CGFloat)jk_width {
    return self.frame.size.width;
}
- (CGFloat)jk_height {
    return self.frame.size.height;
}
- (CGSize)jk_size {
    return self.frame.size;
}

#pragma mark - function
- (void)elast {
    [self elastValues:@[@(0.7),@(1.1),@(1)]];
}
- (void)elastValues:(NSArray<NSValue *> *)values {
    CAKeyframeAnimation *animate = [CAKeyframeAnimation animation];
    animate.keyPath = @"transform.scale";
    animate.values = values;
    animate.duration = 0.2;
    [self.layer addAnimation:animate forKey:nil];
}
- (void)shadowRect {
    self.layer.shadowRadius = 5;
//    CGRect shadowBounds = CGRectMake(-1, -1, self.jk_width + 2, self.jk_height + 2);
    self.layer.cornerRadius = 5;
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowBounds].CGPath;
//    self.layer.shadowOpacity = 0.5;
}
- (JKBaseView *)viewWithMarkCode:(NSString *)markCode {

    for (JKBaseView *view in self.subviews) {
        if ([view isKindOfClass:[JKBaseView class]]) {
            NSString *code = ((JKBaseView *)view).markCode;
            if (code && code.length && [code isEqualToString:markCode]) {
                return view;
            }
        }
    }
    return nil;
}
@end
