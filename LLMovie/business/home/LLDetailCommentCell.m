//
//  LLDetailCommentCell.m
//  LLMovie
//
//  Created by xin xian on 2021/3/23.
//

#import "LLDetailCommentCell.h"

@interface LLDetailCommentCell()
@property (nonatomic, strong) UIImageView *headIV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation LLDetailCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *headIV = [[UIImageView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(43), XX_ADJUST_SIZE(43), XX_ADJUST_SIZE(92), XX_ADJUST_SIZE(92))];
        headIV.backgroundColor = UIColorFromString(@"A2A2A2");
        headIV.layer.cornerRadius = headIV.height/2;
        headIV.layer.masksToBounds = YES;
        [self.contentView addSubview:self.headIV=headIV];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(XX_SCREEN_WIDTH-XX_ADJUST_SIZE(250+43), XX_ADJUST_SIZE(43), XX_ADJUST_SIZE(250), XX_ADJUST_SIZE(49))];
        timeLabel.font = XX_SYSTEM_FONT(35);
        timeLabel.textColor = UIColorFromString(@"AAAAAA");
        timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLabel=timeLabel];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headIV.right + XX_ADJUST_SIZE(29), XX_ADJUST_SIZE(43), timeLabel.left-XX_ADJUST_SIZE(29*2)-headIV.right, XX_ADJUST_SIZE(63))];
        nameLabel.font = XX_SYSTEM_FONT(46);
        nameLabel.textColor = UIColorFromString(@"AAAAAA");
        [self.contentView addSubview:self.nameLabel=nameLabel];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom + XX_ADJUST_SIZE(23), XX_SCREEN_WIDTH-XX_ADJUST_SIZE(43)-nameLabel.left, XX_ADJUST_SIZE(58))];
        descLabel.font = XX_SYSTEM_FONT(40);
        descLabel.textColor = UIColorFromString(@"222222");
        descLabel.numberOfLines = 0;
        [self.contentView addSubview:self.descLabel=descLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(headIV.left, XX_ADJUST_SIZE(230)-XX_LINE_SIZE, XX_SCREEN_WIDTH-headIV.left, XX_LINE_SIZE)];
        lineView.backgroundColor = UIColorFromString(@"E8E8E8");
        [self.contentView addSubview:self.lineView=lineView];
    }
    return self;
}

- (void)ll_setHideLine {
    self.lineView.hidden = YES;
}

- (void)setData:(LLMovieCommentModel *)data {
    [self.headIV xx_imageWithUrl:data.userIcon];
    self.nameLabel.text = data.userName;
    self.timeLabel.text = data.time.ll_time;
    
    {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = XX_ADJUST_SIZE(10);
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:data.content attributes:@{
            NSFontAttributeName: XX_SYSTEM_FONT(40),
            NSParagraphStyleAttributeName: style,
        }];
        self.descLabel.attributedText = attr;
    }
    
    self.descLabel.height = data.ll_contentHeight;
    self.lineView.top = XX_ADJUST_SIZE(230-58)+data.ll_contentHeight-XX_LINE_SIZE;
    
}


@end
