//
//  LLCircleListCell.h
//  LLMovie
//
//  Created by xin xian on 2021/3/14.
//

#import <UIKit/UIKit.h>
#import "LLCircleModel.h"
@protocol LLCircleListCellDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface LLCircleListCell : UITableViewCell
@property (nonatomic, weak) id <LLCircleListCellDelegate> delegate;
- (void)setData:(LLCircleModel *)data;
- (void)ll_setInDetail; // 设置详情模式
- (UIImageView *)ll_imageViewForIndex:(NSInteger)index;
@end

@protocol LLCircleListCellDelegate <NSObject>
@optional
- (void)cellClickHeader:(LLCircleListCell *)cell;
- (void)cellClickImage:(LLCircleListCell *)cell imageView:(UIImageView *)imageView;
- (void)cellClickCollect:(LLCircleListCell *)cell;
- (void)cellClickComment:(LLCircleListCell *)cell;
- (void)cellClickReport:(LLCircleListCell *)cell;
@end

NS_ASSUME_NONNULL_END
