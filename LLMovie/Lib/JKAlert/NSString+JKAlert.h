//
//  NSString+JKAlert.h
//  AlertAssemble
//
//  Created by 四威 on 2016/8/3.
//  Copyright © 2016年 JeanKyle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (JKAlert)

/**
 *  获取单行字符串宽度
 *
 *  @param font 字体
 *
 *  @return CGFloat
 */
- (CGFloat)widthWithFont:(UIFont *)font;
/**
 *  获取多行字符串高度
 *
 *  @param width 最大宽度
 *  @param font  字体
 *
 *  @return CGFloat
 */
- (CGFloat)heightWithWidth:(CGFloat)width font:(UIFont *)font;

@end
