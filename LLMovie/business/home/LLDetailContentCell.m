//
//  LLDetailContentCell.m
//  LLMovie
//
//  Created by xin xian on 2021/3/23.
//

#import "LLDetailContentCell.h"

@interface LLDetailContentCell()
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation LLDetailContentCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(43), XX_ADJUST_SIZE(43), XX_SCREEN_WIDTH - XX_ADJUST_SIZE(43*2), XX_ADJUST_SIZE(58))];
        contentLabel.font = XX_SYSTEM_FONT(40);
        contentLabel.textColor = UIColorFromString(@"222222");
        contentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel=contentLabel];
        
    }
    return self;
}

- (void)setData:(NSString *)content height:(CGFloat)height {
    if (!content) {
        content = @"";
    }
    {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = XX_ADJUST_SIZE(10);
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:content attributes:@{
            NSFontAttributeName: XX_SYSTEM_FONT(40),
            NSParagraphStyleAttributeName: style,
        }];
        self.contentLabel.attributedText = attr;
    }
    self.contentLabel.height = height;
}

@end
