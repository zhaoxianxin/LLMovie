//
//  UIScrollView+VisibleCenter.m
//  LLMovie
//
//  Created by xin xian on 2021/3/23.
//

#import "UIScrollView+VisibleCenter.h"

@implementation UIScrollView (VisibleCenter)

- (void)xx_scrollRectToVisibleCenteredOn:(CGRect)visibleRect animated:(BOOL)animated {
    UIEdgeInsets inset = self.contentInset;
    CGRect frameForLayout = self.frame;
    CGPoint centerPoint = CGPointMake(visibleRect.origin.x + visibleRect.size.width / 2 , visibleRect.origin.y + visibleRect.size.height / 2);
    CGPoint offset = CGPointMake(centerPoint.x - frameForLayout.size.width / 2 , centerPoint.y - frameForLayout.size.height / 2);
    offset.x = MAX(offset.x, -inset.left);
    offset.x = MIN(offset.x, self.contentSize.width - frameForLayout.size.width + inset.right);
    offset.y = MAX(offset.y, -inset.top);
    offset.y = MIN(offset.y, self.contentSize.height - frameForLayout.size.height + inset.bottom);
    [self setContentOffset:offset];
}

@end
