//
//  UIScrollView+VisibleCenter.h
//  LLMovie
//
//  Created by xin xian on 2021/3/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (VisibleCenter)
- (void)xx_scrollRectToVisibleCenteredOn:(CGRect)visibleRect animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
