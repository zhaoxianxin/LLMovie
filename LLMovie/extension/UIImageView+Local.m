//
//  UIImageView+Local.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/12.
//

#import "UIImageView+Local.h"
#import <SDWebImage/SDWebImage.h>

@implementation UIImageView (Local)
- (void)xx_imageWithUrl:(NSString *)url {
    if ([url isKindOfClass:[UIImage class]]) {
        self.image = (UIImage *)url;
    } else if ([url hasPrefix:@"xx_"]) {
        self.image = [UIImage xx_imageWithFileName:url];
    } else {
        [self sd_setImageWithURL:[NSURL URLWithString:url]];
    }
}

- (void)xx_imageWithWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = theImage;
}

@end

@implementation UIImage(Local)

+ (id)xx_imageWithFileName:(NSString *)fileName {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
    if (!imagePath) {
        imagePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg"];
    }
    if (!imagePath) {
        imagePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpeg"];
    }
    return [UIImage imageWithContentsOfFile:imagePath];
}

+ (UIImage *)xx_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end

