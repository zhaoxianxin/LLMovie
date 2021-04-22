//
//  LLSettingBlackCell.m
//  LLMovie
//
//  Created by xin xian on 2021/3/24.
//

#import "LLSettingBlackCell.h"

@interface LLSettingBlackCell()
@property (nonatomic, strong) UIImageView *iconIV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *removeButton;
@end

@implementation LLSettingBlackCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(43), XX_ADJUST_SIZE(23), XX_ADJUST_SIZE(115), XX_ADJUST_SIZE(115))];
        iconIV.layer.cornerRadius = iconIV.height/2;
        iconIV.layer.masksToBounds = YES;
        [self.contentView addSubview:self.iconIV=iconIV];
        
        UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        removeButton.frame = CGRectMake(XX_SCREEN_WIDTH-XX_ADJUST_SIZE(288), 0, XX_ADJUST_SIZE(288), XX_ADJUST_SIZE(161));
        [removeButton setTitle:@"移出黑名单" forState:UIControlStateNormal];
        [removeButton setTitleColor:UIColorFromString(@"FC7C4F") forState:UIControlStateNormal];
        removeButton.titleLabel.font = XX_SYSTEM_FONT(40);
        [removeButton addTarget:self action:@selector(ll_clickRemove) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.removeButton=removeButton];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconIV.right + XX_ADJUST_SIZE(29), XX_ADJUST_SIZE(49), removeButton.left-XX_ADJUST_SIZE(29*2)-iconIV.right, XX_ADJUST_SIZE(63))];
        nameLabel.font = XX_SYSTEM_FONT(46);
        nameLabel.textColor = UIColorFromString(@"222222");
        [self.contentView addSubview:self.nameLabel=nameLabel];
        
    }
    return self;
}

- (void)ll_clickRemove {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellDidClickRemoveBlack:)]) {
        [self.delegate cellDidClickRemoveBlack:self];
    }
}

- (void)setData:(LLUserModel *)data {
    [self.iconIV xx_imageWithUrl:data.userIcon];
    self.nameLabel.text = data.userName;
}

@end
