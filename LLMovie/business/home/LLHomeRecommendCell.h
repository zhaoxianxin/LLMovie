//
//  LLHomeRecommendCell.h
//  LLMovie
//
//  Created by xin xian on 2021/3/14.
//

#import <UIKit/UIKit.h>
#import "LLMovieModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LLHomeRecommendCellDelegate;

@interface LLHomeRecommendCell : UITableViewCell
@property (nonatomic, weak) id <LLHomeRecommendCellDelegate> delegate;
- (void)setData:(LLMovieModel *)data;
@end

@protocol LLHomeRecommendCellDelegate <NSObject>
@optional
- (void)recommendCellDidClickActionButton:(LLHomeRecommendCell *)recommendCell;
@end

NS_ASSUME_NONNULL_END
