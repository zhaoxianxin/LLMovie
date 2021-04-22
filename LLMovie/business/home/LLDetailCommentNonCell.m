//
//  LLDetailCommentNonCell.m
//  LLMovie
//
//  Created by xin xian on 2021/3/23.
//

#import "LLDetailCommentNonCell.h"

@implementation LLDetailCommentNonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((XX_SCREEN_WIDTH-XX_ADJUST_SIZE(184))/2, XX_ADJUST_SIZE(86), XX_ADJUST_SIZE(184), XX_ADJUST_SIZE(184))];
        imageView.image = [UIImage imageNamed:@"detail_non_icon"];
        [self.contentView addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.left, imageView.bottom + XX_ADJUST_SIZE(23), imageView.width, XX_ADJUST_SIZE(49))];
        titleLabel.font = XX_SYSTEM_FONT(35);
        titleLabel.textColor = UIColorFromString(@"999999");
        titleLabel.text = @"暂无评论";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleLabel];
    }
    return self;
}

@end
