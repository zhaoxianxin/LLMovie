//
//  LLStartView.h
//  LLMovie
//
//  Created by xin xian on 2021/3/23.
//

#import "GBStarRateView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLStartView : GBStarRateView
+ (id)ll_startWithScore:(CGFloat)score;
+ (id)ll_startWithScore:(CGFloat)score size:(CGFloat)size;
@end

NS_ASSUME_NONNULL_END
