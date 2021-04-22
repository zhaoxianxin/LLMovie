//
//  LLBaseViewController.h
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/12.
//

#import <UIKit/UIKit.h>
#import "LLNavigationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLBaseViewController : UIViewController
@property(nonatomic, strong, readonly) LLNavigationView *naView;
- (void)setNavTitle:(NSString *)title; // 默认显示返回按钮
- (void)setNavTitle:(NSString *)title showBack:(BOOL)showBack;
- (void)setShowNothingView:(BOOL)show;

- (BOOL)supportGesturesToBack;
- (void)backClick;
- (void)rightClick;
- (NSString *)nothingText;
- (NSString *)nothingImage;
- (UIButton *)nothingButton;
@end

NS_ASSUME_NONNULL_END
