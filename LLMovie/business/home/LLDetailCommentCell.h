//
//  LLDetailCommentCell.h
//  LLMovie
//
//  Created by xin xian on 2021/3/23.
//

#import <UIKit/UIKit.h>
#import "LLMovieCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLDetailCommentCell : UITableViewCell
- (void)setData:(LLMovieCommentModel *)data;
- (void)ll_setHideLine;
@end

NS_ASSUME_NONNULL_END
