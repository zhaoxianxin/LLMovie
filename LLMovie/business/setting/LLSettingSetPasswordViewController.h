//
//  LLSettingSetPasswordViewController.h
//  LLMovie
//
//  Created by xin xian on 2021/3/16.
//

#import "LLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
// 找回密码登陆 + 修改登陆密码
@interface LLSettingSetPasswordViewController : LLBaseViewController
@property (nonatomic, assign) BOOL isLogin; // 是否是找回密码登陆
@property (nonatomic, copy) NSString *phoneNum;
@end

NS_ASSUME_NONNULL_END
