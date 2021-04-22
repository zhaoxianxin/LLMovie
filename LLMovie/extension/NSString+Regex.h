//
//  NSString+Regex.h
//  LLMovie
//
//  Created by xin xian on 2021/3/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define XX_FORMAT(__str__) @"SELF MATCHES %@", __str__

@interface NSString (Regex)
- (BOOL)xx_isPhoneNumber;
- (BOOL)xx_isNumber;
@end

@interface NSString (LLTime)
- (NSString *)ll_time;
@end

NS_ASSUME_NONNULL_END
