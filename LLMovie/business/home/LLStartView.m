//
//  LLStartView.m
//  LLMovie
//
//  Created by xin xian on 2021/3/23.
//

#import "LLStartView.h"

@implementation LLStartView

+ (id)ll_startWithScore:(CGFloat)score {
    return [self ll_startWithScore:score size:XX_ADJUST_SIZE(35)];
}

+ (id)ll_startWithScore:(CGFloat)score size:(CGFloat)size {
    LLStartView *scoreView = [[LLStartView alloc] initWithFrame:CGRectMake(0, 0, size*5+XX_ADJUST_SIZE(3*4), size) style:GBStarRateViewStyleIncompleteStar numberOfStars:5 isAnimation:YES delegate:nil];
    scoreView.starSize = CGSizeMake(size, size);
    scoreView.spacingBetweenStars = XX_ADJUST_SIZE(3);
    scoreView.allowClickScore = NO;
    scoreView.allowSlideScore = NO;
    scoreView.isAnimation = NO;
    scoreView.currentStarRate = score;
    return scoreView;
}

- (void)setCurrentStarRate:(CGFloat)currentStarRate {
    currentStarRate /= 2.0;
    [super setCurrentStarRate:currentStarRate];
}

@end
