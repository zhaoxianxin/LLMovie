//
//  UIView+JKAlert.h
//  AlertAssemble
//
//  Created by 四威 on 2016/7/28.
//  Copyright © 2016年 JeanKyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKBaseView.h"

/**
 *  标识类型
 */
typedef NS_ENUM(NSUInteger, JKInformStyle) {
    /**
     *  钩
     */
    JKInformStyleTick = 0,
    /**
     *  叉
     */
    JKInformStyleCross = 1 << 0,
};

/**
 *  取半函数
 *
 *  @param number 操作数
 *

 */
CGFloat half(CGFloat number);
/**
 *  两倍函数
 *
 *  @param number 操作数
 *

 */
CGFloat doubling(CGFloat number);
/**
 *  角度转浮点型
 *
 *  @param angle 角度(数学单位)
 *
 
 */
CGFloat angleMake(CGFloat angle);
/**
 *  百分值
 *
 *  @param num 操作数
 *

 */
CGFloat percent(CGFloat num);

#define ONE_SEVENTH 0.14

#define SCREEN_CENTER CGPointMake(half(XX_SCREEN_WIDTH), half(XX_SCREEN_HEIGHT))
#define ANIMATE_DURATION 0.5
#define LINE_WIDTH 2.0

@interface UIView (JKAlert)

//视图左边
@property (nonatomic, assign) CGFloat jk_x;
//视图顶部
@property (nonatomic, assign) CGFloat jk_y;
//视图宽度
@property (nonatomic, assign) CGFloat jk_width;
//视图高度
@property (nonatomic, assign) CGFloat jk_height;
//视图尺寸
@property (nonatomic, assign) CGSize jk_size;

- (void)elast;

- (void)elastValues:(NSArray<NSValue *> *)values;

- (void)shadowRect;

- (JKBaseView *)viewWithMarkCode:(NSString *)markCode;
@end
