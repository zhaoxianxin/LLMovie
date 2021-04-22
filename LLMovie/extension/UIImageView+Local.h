//
//  UIImageView+Local.h
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Local)
- (void)xx_imageWithUrl:(NSString *)url;
- (void)xx_imageWithWithColor:(UIColor *)color;
@end

@interface UIImage(Local)
+ (id)xx_imageWithFileName:(NSString *)fileName;
+ (UIImage *)xx_imageWithColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
