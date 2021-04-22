//
//  XXDeviceAdaptor.h
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define XX_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) // width
#define XX_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) // height

/*设备型号*/
#define XX_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define XX_IPHONE_4_OR_LESS (XX_IPHONE && XX_SCREEN_HEIGHT < 568.0)
#define XX_IPHONE_5 (XX_IPHONE && XX_SCREEN_HEIGHT == 568.0)
#define XX_IPHONE_6 (XX_IPHONE && XX_SCREEN_HEIGHT == 667.0)//4.7寸
#define XX_IPHONE_6P (XX_IPHONE && XX_SCREEN_HEIGHT == 736.0)//5.5寸
#define XX_IPHONE_X (XX_IPHONE && XX_SCREEN_HEIGHT == 812.0) //5.8寸
#define XX_IPHONE_XROrMax (XX_IPHONE && XX_SCREEN_HEIGHT == 896.0) //6.1、6.5寸
#define XX_IPHONE_12 (XX_IPHONE && XX_SCREEN_HEIGHT == 844.0) //12、12pro
#define XX_IPHONE_12_MAX (XX_IPHONE && XX_SCREEN_HEIGHT == 926.0) // 12 pro max
#define XX_IPHONE_12_MINI (XX_IPHONE && XX_SCREEN_HEIGHT == 780.0) // 12 mini
#define XX_IPHONE_FRINGE (XX_IPHONE_X || XX_IPHONE_XROrMax || XX_IPHONE_12 || XX_IPHONE_12_MAX || XX_IPHONE_12_MINI) //iphone X刘海屏系列

#define XX_NAVIGATION_HEIGHT (XX_IPHONE_FRINGE ? (XX_ADJUST_SIZE(168 + 52.5)) : (XX_ADJUST_SIZE(168))) // 导航栏的高度
#define XX_TABBAR_HEIGHT (XX_IPHONE_FRINGE ? (83) : (49)) // tabBar的高度
#define XX_SAFE_BOTTOM (XX_IPHONE_FRINGE?34:0) // 刘海屏底部留出34
#define XX_SAFE_TOP ((XX_IPHONE_FRINGE) ? (44) : (20))
#define XX_ADJUST_SIZE(size) ([XXDeviceAdaptor adaptorSize:(size)]) // size -> 1080
#define XX_LINE_SIZE (1 / [UIScreen mainScreen].scale)

#define XX_SYSTEM_FONT(__size__) [UIFont systemFontOfSize:XX_ADJUST_SIZE(__size__)]

@interface XXDeviceAdaptor : NSObject
+ (CGFloat)adaptorSize:(CGFloat)size;
@end

NS_ASSUME_NONNULL_END
