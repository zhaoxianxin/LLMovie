//
//  UIColor+XXHex.h
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/12.
//


#import <UIKit/UIKit.h>

@interface UIColor (XXHex)

/**
将八位/六位 十六进制字符 ----> 转为颜色
八位时'#EF9F1CDD'后两位为透明度
六位时'#9F1CDD'默认为不透明
*/
UIKIT_EXTERN UIColor *UIColorFromString(NSString *string);


/// 将六位十六进制字符 及透明度 ----> 转为颜色
/// @param colorStr 六位'#9F1CDD'字符
/// @param alpha 透明度 (0.0 ~ 1.0)
UIColor * UIColorFromStringAlpha(NSString *colorStr,CGFloat alpha);


/*-----------------------------------*/

/**
将颜色 转为十六进制字符 支持带透明度的转换
*/
+ (NSString *)zf_hexStringFromColor:(UIColor *)color;

/**
将颜色 转为十六进制字符
*/
UIKIT_EXTERN NSString *NSStringFromColor(UIColor *color);


@end

 
