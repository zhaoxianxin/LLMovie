//
//  LLUserManager.h
//  LLMovie
//
//  Created by xin xian on 2021/3/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString * const XXUserDidLoginNotifation;
FOUNDATION_EXTERN NSString * const XXUserDidLoginOutNotifation;
FOUNDATION_EXTERN NSString * const XXUserInfoDidChangeNotifation;

@interface LLUserManager : NSObject
+ (NSString *)loginNick;
+ (NSString *)loginUserName;
+ (NSString *)loginUserId;
+ (NSString *)loginImage;
+ (BOOL)isLogin;
+ (void)ll_showLogin;
+ (void)loginWithUser:(NSString *)phoneNum;
+ (void)ll_loginOut;
+ (void)ll_setPassword;
+ (BOOL)hasSetPassword;
+ (void)saveNick:(NSString *)nick;
+ (void)saveImage:(NSString *)image;
@end

NS_ASSUME_NONNULL_END
