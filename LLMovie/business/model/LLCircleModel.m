//
//  LLCircleModel.m
//  LLMovie
//
//  Created by xin xian on 2021/3/14.
//

#import "LLCircleModel.h"

@interface LLCircleModel()
{
    BOOL _hasCacheHeight;
    CGFloat _cacheContentHeight;
    CGFloat _cacheCellHeight;
}
@end

@implementation LLCircleModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"imageList" : [NSString class],
        @"commentList" : [LLMovieCommentModel class],
    };
}

- (NSString *)content {
    if (!_content) {
        return @"";
    }
    return _content;
}

- (NSInteger)commentCount {
    return self.commentList.count;
}

- (NSMutableArray<LLMovieCommentModel *> *)commentList {
    if (!_commentList) {
        _commentList = [[NSMutableArray alloc] init];
    }
    return _commentList;
}

- (void)xx_cacheContentHeight {
    if (_hasCacheHeight) {
        return;
    }
    //文字高度
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XX_SCREEN_WIDTH-XX_ADJUST_SIZE(43*2), XX_ADJUST_SIZE(63))];
    label.numberOfLines = 0;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = XX_ADJUST_SIZE(10);
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:self.content attributes:@{
        NSFontAttributeName: XX_SYSTEM_FONT(46),
        NSParagraphStyleAttributeName: style,
    }];
    label.attributedText = attr;
    [label sizeToFit];
    if (label.height < XX_ADJUST_SIZE(63)) {
        label.height = XX_ADJUST_SIZE(63);
    }
    
    _cacheContentHeight = label.height;
    
    //图片高度
    NSInteger imageCount = self.imageList.count;
    CGFloat imageHeight = 0;
    if (imageCount == 0) {
        imageHeight = 0;
    } else if (imageCount == 1) {
        imageHeight = XX_ADJUST_SIZE(680-139);
    } else if (imageCount <= 3) {
        imageHeight = XX_ADJUST_SIZE(317);
    } else {
        imageHeight = XX_ADJUST_SIZE(317*2+23);
    }
    
    //总高度
    _cacheCellHeight = XX_ADJUST_SIZE(207+43+139) + _cacheContentHeight + imageHeight;
    
    _hasCacheHeight = YES;
}

- (CGFloat)xx_contentHeight {
    [self xx_cacheContentHeight];
    return _cacheContentHeight;
}

- (CGFloat)xx_cellHeight {
    [self xx_cacheContentHeight];
    return _cacheCellHeight;
}

- (BOOL)ll_isSelf {
    return [self.userId isEqualToString:[LLUserManager loginUserId]];
}

- (void)ll_setIsMyCircle {
    if (![LLUserManager isLogin]) {
        return;
    }
    self.userId = [LLUserManager loginUserId];
    self.userName = [LLUserManager loginNick];
    self.userNum = [[NSUserDefaults standardUserDefaults] stringForKey:XX_CACHE_NAME_KEY];
    self.userIcon = [LLUserManager loginImage];
}

- (NSString *)userName {
    if ([_userName length] > 0) {
        return _userName;
    }
    return self.userNum;
}

@end
