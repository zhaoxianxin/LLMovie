//
//  LLMovieModel.h
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/12.
//

#import <Foundation/Foundation.h>
#import "LLMovieRoleModel.h"
#import "LLMovieCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLMovieModel : NSObject
@property (nonatomic, assign) int modelId;
@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, copy) NSString *titleEng; // 标题英文
@property (nonatomic, copy) NSString *imageUrl; //大图片
@property (nonatomic, copy) NSString *thumbImage; //小图图片
@property (nonatomic, copy) NSString *desc; //描述文案
@property (nonatomic, assign) CGFloat score; // 评分
@property (nonatomic, strong) NSArray *labelList;  // 标签
@property (nonatomic, assign) NSInteger flowWill;  //多少人想看
@property (nonatomic, assign) NSInteger flowDid;  //多少人已看
@property (nonatomic, assign) BOOL hasFlowWill;  // 是否已想看
@property (nonatomic, copy) NSString *showTime;  // 上映时间
@property (nonatomic, assign) NSInteger totalMinute; // 时长（分钟）
@property (nonatomic, copy) NSString *showPlace; //上映国家
@property (nonatomic, assign) BOOL hasScored;  // 是否已经评分
@property (nonatomic, assign) CGFloat myScore; // 我的评分
@property (nonatomic, strong) NSArray <LLMovieRoleModel *> *roleList; // 演员列表
@property (nonatomic, strong) NSMutableArray <LLMovieCommentModel *> *commentList; // 评论列表

//获取内容高度
- (CGFloat)ll_contentHeight;
@end

NS_ASSUME_NONNULL_END
