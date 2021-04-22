//
//  LLHomeDetailViewController.h
//  LLMovie
//
//  Created by xin xian on 2021/3/12.
//

#import "LLBaseViewController.h"
@class LLMovieModel;

NS_ASSUME_NONNULL_BEGIN

@interface LLHomeDetailViewController : LLBaseViewController
@property (nonatomic, strong) LLMovieModel *model;
@property (nonatomic, copy) void(^WillStateChanged)(id obj); // 想看状态变化
@end

NS_ASSUME_NONNULL_END
