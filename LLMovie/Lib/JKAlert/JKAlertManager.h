//
//  JKAlertManager.h
//  AlertAssemble
//
//  Created by 四威 on 2016/8/1.
//  Copyright © 2016年 JeanKyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKInformView.h"
#import "JKWaitingView.h"
#import "JKAdapterLabel.h"
#import "NSObject+JKAlert.h"


extern NSString *const JKMaskCode;
extern NSString *const JKInformCode;
extern NSString *const JKWaitCode;
extern NSString *const JKContainCode;
extern NSString *const JKTextCode;


typedef void (^jk_block_fl)(CGFloat num);

//快速引用单例
#define JK_M [JKAlertManager manager]
//默认持续时间
#define DURATION_DEFAULT 2.0

@interface JKAlertManager : NSObject

//可交互视图
@property (nonatomic, strong) JKBaseView *maskView;
//标识视图
@property (nonatomic, strong) JKInformView *informView;
//容器视图
@property (nonatomic, strong) JKBaseView *containView;
//文本视图
@property (nonatomic, strong) JKAdapterLabel *textLabel;
//等待视图
@property (nonatomic, strong) JKWaitingView *waitView;
//主窗口是否存在弹窗
@property (nonatomic, assign) BOOL isAlerted;
//主窗口
@property (nonatomic, strong) UIWindow *mainWindow;
//持续时间
@property (nonatomic, assign) NSTimeInterval duration;

+ (instancetype)manager;

- (void)dismissElast;

- (void)cleanAllAlertViewsWithMarkCodeInt:(NSUInteger)markCodeInt;

- (void)hideAllAlertViewsWithMarkCodeInt:(NSUInteger)markCodeInt;

- (void)elastAllAlertViews;

- (void)dismissNormalWithMarkCodeInt:(NSUInteger)markCodeInt;

- (void)dismissDuration:(NSTimeInterval)duration markCodeInt:(NSUInteger)markCodeInt completionBlock:(void(^)(void))completionBlock;

- (void)coverEnable:(BOOL)enable;

- (void)containSide:(CGFloat)side block:(jk_block_fl)block;

- (void)containSize:(CGSize)size block:(jk_block_fl)block;

- (void)waitingJudge:(BOOL)isAlert block:(jk_block_t)block;

- (void)markCodeAllAlertViews:(NSUInteger)markCode;

- (NSUInteger)timestamp;
@end

