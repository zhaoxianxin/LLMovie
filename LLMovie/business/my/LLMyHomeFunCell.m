//
//  LLMyHomeFunCell.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/15.
//

#import "LLMyHomeFunCell.h"

@interface LLMyHomeFunCell()
@property (nonatomic, strong) UIView *lineView;
@end

@implementation LLMyHomeFunCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(58), 0, XX_SCREEN_WIDTH/2, XX_ADJUST_SIZE(138))];
        titleLabel.font = XX_SYSTEM_FONT(46);
        titleLabel.textColor = UIColorFromString(@"222222");
        [self.contentView addSubview:self.titleLabel=titleLabel];
        
        UIImageView *arrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(XX_SCREEN_WIDTH-XX_ADJUST_SIZE(43+20), XX_ADJUST_SIZE(138-35)/2, XX_ADJUST_SIZE(20), XX_ADJUST_SIZE(35))];
        arrowIV.image = [UIImage imageNamed:@"my_func_arrow"];
        [self.contentView addSubview:self.arrowIV=arrowIV];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(58, XX_ADJUST_SIZE(138)-XX_LINE_SIZE, XX_SCREEN_WIDTH-XX_ADJUST_SIZE(58), XX_LINE_SIZE)];
        lineView.backgroundColor = UIColorFromString(@"EDEDED");
        lineView.hidden = YES;
        [self.contentView addSubview:self.lineView=lineView];
    }
    return self;
}

- (void)ll_showLine {
    self.lineView.hidden = NO;
}

@end
