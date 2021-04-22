//
//  LLHomeRecommendNoneCell.m
//  LLMovie
//
//  Created by xin xian on 2021/3/25.
//

#import "LLHomeRecommendNoneCell.h"

@interface LLHomeRecommendNoneCell()
@property (nonatomic, strong) UIImageView *noneIcon;
@end

@implementation LLHomeRecommendNoneCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *noneIcon = [[UIImageView alloc] initWithFrame:CGRectMake((XX_SCREEN_WIDTH-XX_ADJUST_SIZE(374))/2, XX_ADJUST_SIZE(282), XX_ADJUST_SIZE(374), XX_ADJUST_SIZE(472))];
        noneIcon.image = [UIImage imageNamed:@"ll_my_data_none"];
        [self.contentView addSubview:self.noneIcon=noneIcon];
        
    }
    return self;
}

@end
