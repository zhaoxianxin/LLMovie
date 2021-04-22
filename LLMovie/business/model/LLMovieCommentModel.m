//
//  LLMovieCommentModel.m
//  LLMovie
//
//  Created by xin xian on 2021/3/14.
//

#import "LLMovieCommentModel.h"

@interface LLMovieCommentModel()
{
    BOOL _hasCacheHeight;
    CGFloat _cacheContentHeight;
}

@end

@implementation LLMovieCommentModel

- (void)ll_cacheContentHeight {
    if (_hasCacheHeight) {
        return;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XX_SCREEN_WIDTH-XX_ADJUST_SIZE((164+43)), XX_ADJUST_SIZE(58))];
    label.numberOfLines = 0;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = XX_ADJUST_SIZE(10);
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:self.content attributes:@{
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

- (NSString *)content {
    if (_content.length > 0) {
        return _content;
    }
    return @"";
}

- (NSString *)userName {
    if (_userName.length == 0) {
        _userName = [[LLShareDataCache shareInstance] ll_nickNameWithId:self.modelId];
    }
    return _userName;
}

@end
