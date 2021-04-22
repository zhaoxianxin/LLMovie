//
//  LLMovieLabel.m
//  LLMovie
//
//  Created by xin xian on 2021/3/23.
//

#import "LLMovieLabel.h"

@implementation LLMovieLabel

+ (id)ll_movieLabelWithOrigin:(CGPoint)origin {
    LLMovieLabel *label = [[LLMovieLabel alloc] initWithFrame:CGRectMake(origin.x, origin.y, XX_ADJUST_SIZE(147), XX_ADJUST_SIZE(63))];
    label.font = XX_SYSTEM_FONT(32);
    label.layer.cornerRadius = label.height/2;
    label.layer.masksToBounds = YES;
    label.layer.backgroundColor = [UIColorFromString(@"FC7C4F1A") CGColor];
    label.textColor = UIColorFromString(@"FC7C4F");
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

@end
