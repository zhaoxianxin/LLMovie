//
//  CALayer+Corner.m
//  LLMovie
//
//  Created by xin xian on 2021/3/13.
//

#import "CALayer+Corner.h"

@implementation CALayer (Corner)

CornerRadii CornerRadiiMake(CGFloat topLeft,CGFloat topRight,CGFloat bottomLeft,CGFloat bottomRight){
     return (CornerRadii){
          topLeft,
          topRight,
          bottomLeft,
          bottomRight,
     };
}

//切圆角函数
CGPathRef XXPathCreateWithRect(CGRect bounds,
                                      CornerRadii cornerRadii)
{
     const CGFloat minX = CGRectGetMinX(bounds);
     const CGFloat minY = CGRectGetMinY(bounds);
     const CGFloat maxX = CGRectGetMaxX(bounds);
     const CGFloat maxY = CGRectGetMaxY(bounds);
     
     const CGFloat topLeftCenterX = minX +  cornerRadii.topLeft;
     const CGFloat topLeftCenterY = minY + cornerRadii.topLeft;
     
     const CGFloat topRightCenterX = maxX - cornerRadii.topRight;
     const CGFloat topRightCenterY = minY + cornerRadii.topRight;
     
     const CGFloat bottomLeftCenterX = minX +  cornerRadii.bottomLeft;
     const CGFloat bottomLeftCenterY = maxY - cornerRadii.bottomLeft;
     
     const CGFloat bottomRightCenterX = maxX -  cornerRadii.bottomRight;
     const CGFloat bottomRightCenterY = maxY - cornerRadii.bottomRight;
     /*
      path : 路径
      m : 变换
      x  y : 画圆的圆心点
      radius : 圆的半径
      startAngle : 起始角度
      endAngle ： 结束角度
      clockwise : 是否是顺时针
      void CGPathAddArc(CGMutablePathRef cg_nullable path,
      const CGAffineTransform * __nullable m,
      CGFloat x, CGFloat y, CGFloat radius, CGFloat startAngle, CGFloat endAngle,
      bool clockwise)
      */
     //虽然顺时针参数是YES，在iOS中的UIView中，这里实际是逆时针
     
     CGMutablePathRef path = CGPathCreateMutable();
     //顶 左
     CGPathAddArc(path, NULL, topLeftCenterX, topLeftCenterY,cornerRadii.topLeft, M_PI, 3 * M_PI_2, NO);
     //顶 右
     CGPathAddArc(path, NULL, topRightCenterX , topRightCenterY, cornerRadii.topRight, 3 * M_PI_2, 0, NO);
     //底 右
     CGPathAddArc(path, NULL, bottomRightCenterX, bottomRightCenterY, cornerRadii.bottomRight,0, M_PI_2, NO);
     //底 左
     CGPathAddArc(path, NULL, bottomLeftCenterX, bottomLeftCenterY, cornerRadii.bottomLeft, M_PI_2,M_PI, NO);
     CGPathCloseSubpath(path);
     return path;
}

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
                               toView:(UIView *)toView {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = toView.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(__bridge NSArray * _Nullable)fromColor.CGColor, (__bridge NSArray * _Nullable)toColor.CGColor, nil];
    gradientLayer.startPoint = fromPoint;
    gradientLayer.endPoint = toPoint;
    gradientLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:1.0], nil];
    [toView.layer addSublayer:gradientLayer];
    return gradientLayer;
}

@end
