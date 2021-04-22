//
//  JKAlertManager.m
//  AlertAssemble
//
//  Created by 四威 on 2016/8/1.
//  Copyright © 2016年 JeanKyle. All rights reserved.
//

#import "JKAlertManager.h"
#import "UIView+JKAlert.h"
#import "AppDelegate.h"


typedef void (^jk_block_views)(JKBaseView *maskView, JKBaseView *containView, JKWaitingView *waitingView, JKAdapterLabel *textLabel, JKInformView *informView);

NSString *const JKMaskCode = @"Mask";
NSString *const JKInformCode = @"Inform";
NSString *const JKWaitCode = @"Wait";
NSString *const JKContainCode = @"Contain";
NSString *const JKTextCode = @"Text";

@implementation JKAlertManager

+ (instancetype)manager {
    static JKAlertManager *m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[self alloc] init];
        m.mainWindow = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window;
        m.duration = DURATION_DEFAULT;
    });
    return m;
}
#pragma mark - 移除视图相关
- (void)cleanAllAlertViewsWithMarkCodeInt:(NSUInteger)markCodeInt {
    
    [self alertViewsWithMarkCodeInt:markCodeInt block:^(JKBaseView *maskView, JKBaseView *containView, JKWaitingView *waitingView, JKAdapterLabel *textLabel, JKInformView *informView) {
        [informView removeFromSuperview];
        [textLabel removeFromSuperview];
        [containView removeFromSuperview];
        [waitingView removeFromSuperview];
        [maskView removeFromSuperview];
        informView = nil;
        textLabel = nil;
        containView = nil;
        waitingView = nil;
        maskView = nil;
    }];
}

- (void)hideAllAlertViewsWithMarkCodeInt:(NSUInteger)markCodeInt {
    
    [self alertViewsWithMarkCodeInt:markCodeInt block:^(JKBaseView *maskView, JKBaseView *containView, JKWaitingView *waitingView, JKAdapterLabel *textLabel, JKInformView *informView) {
        informView.alpha = 0;
        textLabel.alpha = 0;
        containView.alpha = 0;
        waitingView.alpha = 0;
        maskView.alpha = 0;
    }];
}
- (void)elastAllAlertViews {
    [self.informView elast];
    [self.textLabel elast];
    [self.containView elast];
    [self.waitView elast];
}
- (void)dismissNormalWithMarkCodeInt:(NSUInteger)markCodeInt {
    
    [self alertViewsWithMarkCodeInt:markCodeInt block:^(JKBaseView *maskView, JKBaseView *containView, JKWaitingView *waitingView, JKAdapterLabel *textLabel, JKInformView *informView) {
        [UIView animateWithDuration:.3 animations:^{
            [JK_M hideAllAlertViewsWithMarkCodeInt:markCodeInt];
        } completion:^(BOOL finished) {
            [JK_M cleanAllAlertViewsWithMarkCodeInt:markCodeInt];
            JK_M.isAlerted = NO;
        }];
    }];
}
- (void)dismissElastWithMarkCodeInt:(NSInteger)markCodeInt {
    
    [self alertViewsWithMarkCodeInt:markCodeInt block:^(JKBaseView *maskView, JKBaseView *containView, JKWaitingView *waitingView, JKAdapterLabel *textLabel, JKInformView *informView) {
        NSArray *values = @[@(1), @(1.1), @(0)];
        [informView elastValues:values];
        [textLabel elastValues:values];
        [containView elastValues:values];
        [waitingView elastValues:values];
        [UIView animateWithDuration:.2 animations:^{
            [JK_M hideAllAlertViewsWithMarkCodeInt:markCodeInt];
        } completion:^(BOOL finished) {
            [JK_M cleanAllAlertViewsWithMarkCodeInt:markCodeInt];
            JK_M.isAlerted = NO;
        }];
    }];
}
- (void)dismissElast {
    
    NSArray *values = @[@(1), @(1.1), @(0)];
    NSMutableArray *arrWaitViews = [NSMutableArray array];
    NSMutableArray *arrWairs = [NSMutableArray array];
    NSMutableArray *arrAbouts = [NSMutableArray array];
    for (JKBaseView *view in JK_M.mainWindow.subviews) {
        if ([view isKindOfClass:JKBaseView.self]) {
            if ([view.markCode containsString:JKWaitCode]) {
                [arrWairs addObject:view];
            }
        }
    }
    
    [arrWaitViews addObjectsFromArray:arrWairs];
    
    for (NSInteger i = 0; i < arrWairs.count; i++) {
        JKBaseView *view = arrWairs[i];
        NSString *mi = [view.markCode substringToIndex:10];
        for (JKBaseView *aboutView in JK_M.mainWindow.subviews) {
            if ([aboutView isKindOfClass:JKBaseView.self]) {
                if (![aboutView.markCode containsString:JKWaitCode]) {
                    NSString *mia = [aboutView.markCode substringToIndex:10];
                    if ([mia isEqualToString:mi]) {
                        [arrAbouts addObject:aboutView];
                    }
                }
            }
        }
    }
    [arrWaitViews addObjectsFromArray:arrAbouts];
    
    for (JKBaseView *view in arrWaitViews) {
        [view elastValues:values];
//        NSLog(@"主动移除等待相关视图 -> %@", view.markCode);
        [UIView animateWithDuration:.2 animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            JK_M.isAlerted = NO;
        }];
    }
}

- (void)dismissDuration:(NSTimeInterval)duration markCodeInt:(NSUInteger)markCodeInt completionBlock:(void(^)(void))completionBlock {
    
    [self alertViewsWithMarkCodeInt:markCodeInt block:^(JKBaseView *maskView, JKBaseView *containView, JKWaitingView *waitingView, JKAdapterLabel *textLabel, JKInformView *informView) {
//        if(maskView) NSLog(@"移除maskView -> %@", maskView.markCode);
//        if(containView) NSLog(@"移除containView -> %@", containView.markCode);
//        if(informView) NSLog(@"移除informView -> %@", informView.markCode);
//        if(textLabel) NSLog(@"移除textLabel -> %@", textLabel.markCode);
//        if(waitingView) NSLog(@"移除waitView -> %@", waitingView.markCode);
        
        [UIView animateWithDuration:duration animations:^{
            containView.alpha = 0.71;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.3 animations:^{
                [JK_M hideAllAlertViewsWithMarkCodeInt:markCodeInt];
            } completion:^(BOOL finished) {
                [JK_M cleanAllAlertViewsWithMarkCodeInt:markCodeInt];
                JK_M.isAlerted = NO;
                if (completionBlock) {
                    completionBlock();
                }
            }];
        }];
    }];
}

#pragma mark - 按模块添加
- (void)coverEnable:(BOOL)enable {
    JK_M.isAlerted = YES;
    JK_M.maskView = [[JKBaseView alloc] initWithFrame:JK_M.mainWindow.bounds];
    JK_M.maskView.backgroundColor = [UIColor clearColor];
    if (enable) {
        [JK_M.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissElast)]];
    }
    [JK_M.mainWindow addSubview:JK_M.maskView];
}

- (void)containSide:(CGFloat)side block:(jk_block_fl)block {
    
    [self containSize:CGSizeMake(side, side) block:block];
}
- (void)containSize:(CGSize)size block:(jk_block_fl)block {
    JK_M.containView = [[JKBaseView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    JK_M.containView.center = SCREEN_CENTER;
    JK_M.containView.backgroundColor = [UIColor blackColor];
    [JK_M.containView shadowRect];
    JK_M.containView.alpha = 0.7;
    [JK_M.mainWindow addSubview:JK_M.containView];
    if (block) block(size.width == size.height ? size.width : 0);
}
- (void)waitingJudge:(BOOL)isAlert block:(jk_block_t)block {
    if (isAlert) {
        if (block) {
            block();
        }
    }else {
        if (JK_M.isAlerted) {
            [JK_M dismissElast];
        }
    }
}
#pragma mark - functions
- (NSString *)markCodeInt:(NSUInteger)markCodeInt asString:(NSString *)string {
    return [NSString stringWithFormat:@"%lu%@", (unsigned long)markCodeInt, string];
}
- (void)markCodeAllAlertViews:(NSUInteger)markCodeInt {
    JK_M.maskView.markCode = [self markCodeInt:markCodeInt asString:JKMaskCode];
//    if(JK_M.maskView) NSLog(@"生成maskView -> %@", JK_M.maskView.markCode);
    JK_M.containView.markCode = [self markCodeInt:markCodeInt asString:JKContainCode];
//    if(JK_M.containView) NSLog(@"生成containView -> %@", JK_M.containView.markCode);
    JK_M.informView.markCode = [self markCodeInt:markCodeInt asString:JKInformCode];
//    if(JK_M.informView) NSLog(@"生成informView -> %@", JK_M.informView.markCode);
    JK_M.textLabel.markCode = [self markCodeInt:markCodeInt asString:JKTextCode];
//    if(JK_M.textLabel) NSLog(@"生成textLabel -> %@", JK_M.textLabel.markCode);
    JK_M.waitView.markCode = [self markCodeInt:markCodeInt asString:JKWaitCode];
//    if(JK_M.waitView) NSLog(@"生成waitView -> %@", JK_M.waitView.markCode);
}
- (NSUInteger)timestamp {
    //时间戳有可能创建间隔太快，生成一样的，所以换成arc10位随机数，保证唯一性
//    return (NSUInteger)time(NULL);
    return (arc4random() % 1000000000) + 1000000000;
}

- (void)alertViewsWithMarkCodeInt:(NSUInteger)markCodeInt block:(jk_block_views)block {
    JKInformView *informView = (JKInformView *)[JK_M.mainWindow viewWithMarkCode:[self markCodeInt:markCodeInt asString:JKInformCode]];
    JKAdapterLabel *textLabel = (JKAdapterLabel *)[JK_M.mainWindow viewWithMarkCode:[self markCodeInt:markCodeInt asString:JKTextCode]];
    JKBaseView *containView = [JK_M.mainWindow viewWithMarkCode:[self markCodeInt:markCodeInt asString:JKContainCode]];
    JKWaitingView *waitingView = (JKWaitingView *)[JK_M.mainWindow viewWithMarkCode:[self markCodeInt:markCodeInt asString:JKWaitCode]];
    JKBaseView *maskView = [JK_M.mainWindow viewWithMarkCode:[self markCodeInt:markCodeInt asString:JKMaskCode]];
    if (block) {
        block(maskView, containView, waitingView, textLabel, informView);
    }
}

@end
