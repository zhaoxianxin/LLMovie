//
//  CALayer+Corner.h
//  LLMovie
//
//  Created by xin xian on 2021/3/13.
//

#import <QuartzCore/QuartzCore.h>

typedef struct {
     CGFloat topLeft;
     CGFloat topRight;
     CGFloat bottomLeft;
     CGFloat bottomRight;
} CornerRadii;

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (Corner)

CornerRadii CornerRadiiMake(CGFloat topLeft,CGFloat topRight,CGFloat bottomLeft,CGFloat bottomRight);
/**
 四个角切不同角度的圆角
 */
CGPathRef _Nullable XXPathCreateWithRect(CGRect bounds,CornerRadii cornerRadii);

/// 为View设置一个均匀渐变色
/// @param fromColor 开始颜色
/// @param toColor 结束颜色
/// @param fromPoint 开始比例点
/// @param toPoint 结束比例点
/// @param toView 需要设置的View
+ (CALayer *)xx_addGradientLayerColor:(UIColor *)fromColor
                              toColor:(UIColor *)toColor
                            fromPoint:(CGPoint)fromPoint
                              toPoint:(CGPoint)toPoint
                               toView:(UIView *)toView;
@end

NS_ASSUME_NONNULL_END
