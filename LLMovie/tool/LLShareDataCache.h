//
//  LLShareDataCache.h
//  LLMovie
//
//  Created by xin xian on 2021/3/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLShareDataCache : NSObject
+ (void)ll_registCache;
+ (instancetype)shareInstance;
- (NSString *)ll_nickNameWithId:(NSInteger)modeId;
@end

NS_ASSUME_NONNULL_END
