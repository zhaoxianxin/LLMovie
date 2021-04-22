//
//  LLSettingLoginInputCell.h
//  LLMovie
//
//  Created by xin xian on 2021/3/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLSettingLoginInputCell : UIView
@property (nonatomic, strong) UITextField *textInput;
@property (nonatomic, strong) UIButton *codeButton;
- (void)showCodeButton;
- (void)startTimer;
- (void)endTimer;
@end

NS_ASSUME_NONNULL_END
