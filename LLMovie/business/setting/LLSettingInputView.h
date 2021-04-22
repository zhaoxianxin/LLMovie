//
//  LLSettingInputView.h
//  LLMovie
//
//  Created by xin xian on 2021/3/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLSettingInputView : UIView
@property (nonatomic, strong) UITextField *textInput;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) UIView *lineView;
- (void)startTimer;
- (void)endTimer;
@end

NS_ASSUME_NONNULL_END
