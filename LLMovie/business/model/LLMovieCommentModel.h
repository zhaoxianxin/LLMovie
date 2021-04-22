//
//  LLMovieCommentModel.h
//  LLMovie
//
//  Created by xin xian on 2021/3/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLMovieCommentModel : NSObject
@property (nonatomic, assign) int modelId;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *time;
- (CGFloat)ll_contentHeight;
@end

NS_ASSUME_NONNULL_END
