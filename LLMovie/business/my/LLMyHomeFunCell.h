//
//  LLMyHomeFunCell.h
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//高度138px
@interface LLMyHomeFunCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowIV;
- (void)ll_showLine;
@end

NS_ASSUME_NONNULL_END
