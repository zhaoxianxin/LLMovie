//
//  LLCircleDetailViewController.h
//  LLMovie
//
//  Created by xin xian on 2021/3/14.
//

#import "LLBaseViewController.h"
#import "LLCircleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLCircleDetailViewController : LLBaseViewController
@property (nonatomic, strong) LLCircleModel *model;
@property (nonatomic, copy) void(^DeleteCallBack)(id obj); //type 0是更新，1是删除
@end

NS_ASSUME_NONNULL_END
