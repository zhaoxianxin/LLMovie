//
//  JKAlert.h
//  AlertAssemble
//
//  Created by 四威 on 2016/8/1.
//  Copyright © 2016年 JeanKyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+JKAlert.h"

@interface JKAlert : NSObject

/**
 *  正确提示
 */
+ (void)alertTick;
/**
 *  正确提示（定时移除）
 *
 *  @param duration 持续时间(秒)
 */
+ (void)alertTickDuration:(NSTimeInterval)duration;
/**
 *  正确提示 （带文本）
 *
 *  @param text     提示文本
 */
+ (void)alertTickText:(NSString *)text;
/**
 *  正确提示 （定时移除，带文本）
 *
 *  @param text     提示文本
 *  @param duration 持续时间
 */
+ (void)alertTickText:(NSString *)text duration:(NSTimeInterval)duration;
/**
 *  错误提示
 */
+ (void)alertCross;
/**
 *  错误提示 （定时移除）
 *
 *  @param duration 持续时间(秒)
 */
+ (void)alertCrossDuration:(NSTimeInterval)duration;
/**
 *  错误提示 （带文本）
 *
 *  @param text     提示文本
 */
+ (void)alertCrossText:(NSString *)text;
/**
 *  错误提示 （定时移除，带文本）
 *
 *  @param text     提示文本
 *  @param duration 持续时间
 */
+ (void)alertCrossText:(NSString *)text duration:(NSTimeInterval)duration;
/**
 *  等待提示
 *
 *  @param isAlert 控制弹出/移除
 */
+ (void)alertWaiting:(BOOL)isAlert;
/**
 *  等待提示 （带文本）
 *  @dismiss Function (消失方法同样调用 [JKAlert alertWaiting:NO])
 *  @param text 提示文本
 */
+ (void)alertWaitingText:(NSString *)text;
/**
 *  文本提示
 *
 *  @param text 提示内容
 */
+ (void)alertText:(NSString *)text;
/**
 *  文本提示
 *
 *  @param text     提示内容
 *  @param duration 持续时间
 */
+ (void)alertText:(NSString *)text duration:(NSTimeInterval)duration;


/**
 文本提示

 @param text 提示内容
 @param duration 持续时间
 @param completionBlock 完成回调
 */
+ (void)alertText:(NSString *)text duration:(NSTimeInterval)duration completionBlock:(void(^)(void))completionBlock;

/**
 Dismiss显示的Toast
 */
+ (void)alertDismiss;


@end
