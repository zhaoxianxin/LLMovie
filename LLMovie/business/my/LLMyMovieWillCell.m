//
//  LLMyMovieWillCell.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/15.
//

#import "LLMyMovieWillCell.h"

@interface LLMyMovieWillCell()
@property (nonatomic, strong, readwrite) UIImageView *iconIV;
@property (nonatomic, strong, readwrite) UILabel *nameLabel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *stateLabel;
@end

@implementation LLMyMovieWillCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(29), 0, XX_SCREEN_WIDTH-XX_ADJUST_SIZE(29+58), XX_ADJUST_SIZE(403))];
        backView.layer.backgroundColor = [UIColorFromString(@"F0F0F0") CGColor];
        backView.layer.cornerRadius = XX_ADJUST_SIZE(23);
        backView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.backView=backView];
        
        UIImageView *iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(29), XX_ADJUST_SIZE(29), XX_ADJUST_SIZE(282), XX_ADJUST_SIZE(346))];
        iconIV.layer.cornerRadius = XX_ADJUST_SIZE(23);
        iconIV.layer.masksToBounds = YES;
        [backView addSubview:self.iconIV=iconIV];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconIV.right+XX_ADJUST_SIZE(29), XX_ADJUST_SIZE(58), backView.width-XX_ADJUST_SIZE(29+43)-iconIV.right, XX_ADJUST_SIZE(81))];
        nameLabel.font = XX_SYSTEM_FONT(58);
        nameLabel.textColor = UIColorFromString(@"222222");
        [backView addSubview:self.nameLabel=nameLabel];
        
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(backView.width-XX_ADJUST_SIZE(150+43), backView.height - XX_ADJUST_SIZE(43+49), XX_ADJUST_SIZE(150), XX_ADJUST_SIZE(49))];
        stateLabel.font = XX_SYSTEM_FONT(35);
        stateLabel.textColor = UIColorFromString(@"AAAAAA");
        stateLabel.text = @"已想看";
        stateLabel.textAlignment = NSTextAlignmentRight;
        [backView addSubview:self.stateLabel=stateLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, backView.bottom, XX_SCREEN_WIDTH, XX_ADJUST_SIZE(29))];
        [self.contentView addSubview:lineView];
    }
    return self;
}

@end
