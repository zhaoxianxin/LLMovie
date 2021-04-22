//
//  NSObject+JKAlert.m
//  AlertAssemble
//
//  Created by 四威 on 2016/8/3.
//  Copyright © 2016年 JeanKyle. All rights reserved.
//

#import "NSObject+JKAlert.h"
#import <objc/runtime.h>

@implementation NSObject (JKAlert)

- (void)eventsDelay:(NSTimeInterval)delay block:(jk_block_t)block {
    if (block) {
        [self performSelector:@selector(complyBlock:) withObject:block afterDelay:delay];
    }
}

- (void)complyBlock:(jk_block_t)block {
    if (block) {
        block();
    };
}
void mainThread(jk_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}
- (BOOL)hasVariableWithVarName:(NSString *)name {
    unsigned int outCount, i;
    Ivar *ivars = class_copyIvarList(self.class, &outCount);
    for (i = 0; i < outCount; i++) {
        Ivar property = ivars[i];
        NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
        keyName = [keyName stringByReplacingOccurrencesOfString:@"_" withString:@""];
        if ([keyName isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}
@end
