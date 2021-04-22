//
//  LLMovieScoreViewController.h
//  LLMovie
//
//  Created by xin xian on 2021/3/13.
//

#import "LLBaseViewController.h"
@class LLMovieModel;

NS_ASSUME_NONNULL_BEGIN

@interface LLMovieScoreViewController : LLBaseViewController
@property (nonatomic, strong) LLMovieModel *model;
@property (nonatomic, copy) void(^AddScoreCallBack)(id obj);
@end

NS_ASSUME_NONNULL_END
