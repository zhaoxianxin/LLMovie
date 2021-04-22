//
//  NSObject+JKAlert.h
//  AlertAssemble
//
//  Created by 四威 on 2016/8/3.
//  Copyright © 2016年 JeanKyle. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  自定义代码块
 */
typedef void(^jk_block_t)(void);


@interface NSObject (JKAlert)

/**
 *  延时执行代码
 *
 *  @param delay 延时(秒)
 *  @param block 需要执行的代码块
 */
- (void)eventsDelay:(NSTimeInterval)delay block:(jk_block_t)block;
/**
 *  主线程操作
 *
 *  @param block 需要执行的代码块
 */
void mainThread(jk_block_t block);
/**
 *  判断对象有无该属性
 *
 *  @param name 属性名字
 *
 *  @return 返回bool类型
 */
- (BOOL)hasVariableWithVarName:(NSString *)name;

@end
