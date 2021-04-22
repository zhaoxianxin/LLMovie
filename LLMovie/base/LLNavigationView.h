//
//  LLNavigationView.h
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLNavigationView : UIView
@property (nonatomic, assign) BOOL isHighlighted;
@property (nonatomic, strong, readonly) UIButton *backButton;
@property (nonatomic, strong, readonly) UIButton *rightButton;
@property (nonatomic, assign) BOOL showLine;
- (void)setTitle:(NSString *)title;
- (void)hideBack;
- (void)setRightImage:(UIImage *)image;
- (void)setRightTitle:(NSString *)title color:(UIColor *)color frame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
