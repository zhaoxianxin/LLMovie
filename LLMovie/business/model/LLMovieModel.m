//
//  LLMovieModel.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/12.
//

#import "LLMovieModel.h"
@interface LLMovieModel()
{
    BOOL _hasCacheHeight;
    CGFloat _cacheContentHeight;
}
@end

@implementation LLMovieModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"labelList" : [NSString class],
        @"roleList" : [LLMovieRoleModel class],
        @"commentList" : [LLMovieCommentModel class],
    };
}

- (NSMutableArray<NSString *> *)labelList {
    if (!_labelList) {
        _labelList = [[NSMutableArray alloc] init];
    }
    return _labelList;
}

- (NSMutableArray<LLMovieRoleModel *> *)roleList {
    if (!_roleList) {
        _roleList = [[NSMutableArray alloc] init];
    }
    return _roleList;
}

- (NSMutableArray<LLMovieCommentModel *> *)commentList {
    if (!_commentList) {
        _commentList = [[NSMutableArray alloc] init];
    }
    return _commentList;
}

//- (NSString *)imageUrl {
//    return [NSString stringWithFormat:@"ll_home_cell_%d@3x", self.modelId];
//}

- (void)ll_cacheContentHeight {
    if (_hasCacheHeight) {
        return;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XX_SCREEN_WIDTH-XX_ADJUST_SIZE((29+35)*2), XX_ADJUST_SIZE(58))];
    label.numberOfLines = 2;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = XX_ADJUST_SIZE(10);
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:self.desc attributes:@{
        NSFontAttributeName: XX_SYSTEM_FONT(40),
        NSParagraphStyleAttributeName: style,
    }];
    label.attributedText = attr;
    [label sizeToFit];
    if (label.height < XX_ADJUST_SIZE(58)) {
        label.height = XX_ADJUST_SIZE(58);
    }
    _cacheContentHeight = label.height;
    _hasCacheHeight = YES;
}

- (CGFloat)ll_contentHeight {
    [self ll_cacheContentHeight];
    return _cacheContentHeight;
}

- (NSString *)desc {
    if (!_desc) {
        return @"";
    }
    return _desc;
}

@end

