//
//  LLDetailRoleListCell.h
//  LLMovie
//
//  Created by xin xian on 2021/3/23.
//

#import <UIKit/UIKit.h>
#import "LLMovieRoleModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LLDetailRoleListCellDelegate;

@interface LLDetailRoleListCell : UITableViewCell
@property (nonatomic, weak) id <LLDetailRoleListCellDelegate> delegate;
- (void)setData:(NSArray <LLMovieRoleModel *> *)dataList;
- (UIImageView *)ll_roleImageViewForIndex:(NSInteger)index;
@end

@protocol LLDetailRoleListCellDelegate <NSObject>
@optional
- (void)cell:(LLDetailRoleListCell *)cell didClickRoleAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
