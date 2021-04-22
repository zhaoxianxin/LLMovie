//
//  UIColor+XXHex.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/12.
//
#import "UIColor+XXHex.h"

@implementation UIColor (XXHex)

UIColor *UIColorFromStringAlpha(NSString *colorStr,CGFloat alpha) {
    if (!colorStr || [colorStr length] == 0 ) {
        return [UIColor clearColor];
    }
    NSString *alphaHex = HexStringFromSingleFloat(alpha*255);
    colorStr = [colorStr stringByAppendingString:alphaHex];
    return UIColorFromString(colorStr);
}

/**
将十六进制字符 转为颜色
*/
UIColor *UIColorFromString(NSString *string) {
    if (!string || string.length <= 0) {
        return [UIColor clearColor];
    }
    NSString *cString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"] || [cString hasPrefix:@"0x"]) {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    
    NSString *alphaString = @"FF";
    if ([cString length] == 8) {
        alphaString = [cString substringWithRange:NSMakeRange(6, 2)];
        cString = [cString substringToIndex:6];
    }
    
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b, alpha;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    [[NSScanner scannerWithString:alphaString] scanHexInt:&alpha];
    
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha / 255.0f];
}


/**
将颜色 转为十六进制字符
*/
+ (NSString *)zf_hexStringFromColor:(UIColor *)color {
    return NSStringFromColor(color);
}

NSString *NSStringFromColor(UIColor *color) {
    if (!color) {
        return nil;
    }
    CGColorRef colorRf = color.CGColor;
    CGColorSpaceRef colorSpace = CGColorGetColorSpace(colorRf);
    if (!colorSpace) {
        return nil;
    }
    
    CGFloat rFloat = 0.0;
    CGFloat gFloat = 0.0;
    CGFloat bFloat = 0.0;
    CGFloat alphaF = 0.0;
    [color getRed:&rFloat green:&gFloat blue:&bFloat alpha:&alphaF];
    if (alphaF == 0.0) {
        return nil;
    }
    
    NSString *rHex = HexStringFromSingleFloat(rFloat*255);
    NSString *gHex = HexStringFromSingleFloat(gFloat*255);
    NSString *bHex = HexStringFromSingleFloat(bFloat*255);
    NSString *alphaHex = HexStringFromSingleFloat(alphaF*255);
    
    if ([alphaHex isEqualToString:@"FF"]) {
        return [NSString stringWithFormat:@"%@%@%@",rHex,gHex,bHex];
    } else {
        return [NSString stringWithFormat:@"%@%@%@%@",rHex,gHex,bHex,alphaHex];
    }
}




/**
 将 R/G/B 单一颜色值 转为十六进制字符
 */
NSString *HexStringFromSingleFloat(CGFloat sColorValue) {
    NSInteger decimal = (NSInteger)sColorValue;
    NSString *hex = @"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", (long)number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            break;
        }
    }
    
    if (hex.length == 1) {
        hex = [NSString stringWithFormat:@"0%@",hex];
    }
    return hex;
}

@end
