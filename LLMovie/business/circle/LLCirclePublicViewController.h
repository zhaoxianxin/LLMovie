//
//  LLCirclePublicViewController.h
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/15.
//

#import "LLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLCirclePublicViewController : LLBaseViewController
@property (nonatomic, copy) void(^DidPublish)(id obj);
@end

NS_ASSUME_NONNULL_END
