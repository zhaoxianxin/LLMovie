//
//  LLCircleModel.h
//  LLMovie
//
//  Created by xin xian on 2021/3/14.
//

#import <Foundation/Foundation.h>
#import "LLMovieCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLCircleModel : NSObject
@property (nonatomic, assign) int modelId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, copy) NSString *userNum; // 手机号
@property (nonatomic, copy) NSString *userName; // 昵称
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSArray <NSString *> *imageList;
@property (nonatomic, assign) NSInteger collectCount;
@property (nonatomic, assign) BOOL isSetBlack;
@property (nonatomic, assign) BOOL isCollect;
@property (nonatomic, strong) NSMutableArray <LLMovieCommentModel *> *commentList;
- (CGFloat)xx_contentHeight;
- (CGFloat)xx_cellHeight;
- (NSInteger)commentCount;
- (BOOL)ll_isSelf;
- (void)ll_setIsMyCircle;
@end

NS_ASSUME_NONNULL_END
