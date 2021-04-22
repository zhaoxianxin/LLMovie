//
//  LLUserManager.m
//  LLMovie
//
//  Created by xin xian on 2021/3/16.
//

#import "LLUserManager.h"
#import "AppDelegate.h"
#import "LLSettingPWDLoginViewController.h"

NSString * const XXUserDidLoginNotifation = @"XXUserDidLoginNotifation";
NSString * const XXUserDidLoginOutNotifation = @"XXUserDidLoginOutNotifation";
NSString * const XXUserInfoDidChangeNotifation = @"XXUserInfoDidChangeNotifation";

@implementation LLUserManager

+ (NSString *)loginImage {
    if (![self isLogin]) {
        return @"xx_login_icon@3x";
    } else {
        NSString *imageName = [[NSUserDefaults standardUserDefaults] stringForKey:XX_CACHE_IMG_KEY];
        if (imageName.length > 0) {
            return imageName;
        }
        return @"xx_login_icon@3x";
    }
}

+ (NSString *)loginNick {
    if (![self isLogin]) {
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] stringForKey:XX_CACHE_NICK_KEY];
}

+ (NSString *)loginUserName {
    if (![self isLogin]) {
        return @"未登陆";
    }
    NSString *nickName = [[NSUserDefaults standardUserDefaults] stringForKey:XX_CACHE_NICK_KEY];
    if (nickName.length > 0) {
        return nickName;
    }
    return [[NSUserDefaults standardUserDefaults] stringForKey:XX_CACHE_NAME_KEY];
}

+ (void)saveNick:(NSString *)nick {
    [[NSUserDefaults standardUserDefaults] setObject:nick forKey:XX_CACHE_NICK_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveImage:(NSString *)image {
    [[NSUserDefaults standardUserDefaults] setObject:image forKey:XX_CACHE_IMG_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isLogin {
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults] stringForKey:XX_CACHE_NAME_KEY];
    return phoneNum.length > 0;
}

+ (void)loginWithUser:(NSString *)phoneNum {
    [[NSUserDefaults standardUserDefaults] setObject:phoneNum forKey:XX_CACHE_NAME_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:XXUserDidLoginNotifation object:nil userInfo:nil];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate naVC] dismissViewControllerAnimated:YES completion:NULL];
}

+ (void)ll_loginOut {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:XX_CACHE_NAME_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:XXUserDidLoginOutNotifation object:nil userInfo:nil];
    
    UINavigationController *naVC = [(AppDelegate *)[UIApplication sharedApplication].delegate naVC];
    [naVC popToRootViewControllerAnimated:YES];
//    [self ll_showLogin];
}

+ (void)ll_showLogin {
    UINavigationController *naVC = [(AppDelegate *)[UIApplication sharedApplication].delegate naVC];
//    [naVC popToRootViewControllerAnimated:NO];
//
//    UITabBarController *tabBarVC = naVC.viewControllers.firstObject;
//    [tabBarVC setSelectedIndex:0];
    
    
    LLSettingPWDLoginViewController *loginVC = [[LLSettingPWDLoginViewController alloc] init];
    UINavigationController *logonNaVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    logonNaVC.modalPresentationStyle = UIModalPresentationFullScreen;
    logonNaVC.navigationBar.hidden = YES;
    
    [naVC presentViewController:logonNaVC animated:YES completion:NULL];
}

+ (BOOL)hasSetPassword {
    NSString *pwd = [[NSUserDefaults standardUserDefaults] stringForKey:XX_CACHE_PWD_KEY];
    return pwd && [pwd isEqualToString:@"Y"];
}

+ (void)ll_setPassword {
    [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:XX_CACHE_PWD_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)loginUserId {
    if ([self isLogin]) {
        return @"89787666";
    }
    return @"";
}

@end
