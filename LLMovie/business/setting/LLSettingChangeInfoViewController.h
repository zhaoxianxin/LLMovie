//
//  LLSettingChangeInfoViewController.h
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/16.
//

#import "LLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLSettingChangeInfoViewController : LLBaseViewController
@property (nonatomic, copy) void(^ChangeCallback)(id obj);
@end

NS_ASSUME_NONNULL_END
