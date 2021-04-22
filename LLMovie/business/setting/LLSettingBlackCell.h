//
//  LLSettingBlackCell.h
//  LLMovie
//
//  Created by xin xian on 2021/3/24.
//

#import <UIKit/UIKit.h>
#import "LLUserModel.h"

@protocol LLSettingBlackCellDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface LLSettingBlackCell : UITableViewCell
@property (nonatomic, weak) id <LLSettingBlackCellDelegate> delegate;
- (void)setData:(LLUserModel *)data;
@end

@protocol LLSettingBlackCellDelegate <NSObject>
@optional
- (void)cellDidClickRemoveBlack:(LLSettingBlackCell *)cell;
@end

NS_ASSUME_NONNULL_END
