//
//  LLHomeRecommendCell.m
//  LLMovie
//
//  Created by xin xian on 2021/3/14.
//

#import "LLHomeRecommendCell.h"
#import "LLStartView.h"
#import "LLMovieLabel.h"

@interface LLHomeRecommendCell() <GBStarRateViewDelegate>
@property (nonatomic, strong) UIImageView *iconIV;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) LLStartView *scoreView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) NSMutableArray <LLMovieLabel *> *typeLabels;
@property (nonatomic, strong) UIButton *actionButton; // 想看
@property (nonatomic, strong) UILabel *flowLabel;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) LLMovieModel *data;

@end

@implementation LLHomeRecommendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.typeLabels = [NSMutableArray array];
        
        UIImageView *iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(29), 0, XX_SCREEN_WIDTH-XX_ADJUST_SIZE(29*2), XX_ADJUST_SIZE(513))];
        iconIV.backgroundColor = UIColorFromString(@"A2A2A2");
        [self.contentView addSubview:self.iconIV=iconIV];
        {
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            CornerRadii cornerRadii = CornerRadiiMake(XX_ADJUST_SIZE(23), XX_ADJUST_SIZE(23), 0, 0);
            CGPathRef path = XXPathCreateWithRect(iconIV.bounds, cornerRadii);
            shapeLayer.path = path;
            CGPathRelease(path);
            iconIV.layer.mask = shapeLayer;
        }
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(iconIV.left, iconIV.bottom, iconIV.width, XX_ADJUST_SIZE(461))];
        backView.backgroundColor = UIColorFromString(@"F0F0F0");
        [self.contentView addSubview:self.backView=backView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(35), XX_ADJUST_SIZE(43), backView.width-XX_ADJUST_SIZE(35*2+104+23), XX_ADJUST_SIZE(81))];
        titleLabel.font = XX_SYSTEM_FONT(58);
        titleLabel.textColor = UIColorFromString(@"222222");
        [backView addSubview:self.titleLabel=titleLabel];
        
        LLStartView *scoreView = [LLStartView ll_startWithScore:0];
        scoreView.origin = CGPointMake(titleLabel.left, titleLabel.bottom+XX_ADJUST_SIZE(23));
        [backView addSubview:self.scoreView=scoreView];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.left, scoreView.bottom+XX_ADJUST_SIZE(23), backView.width-XX_ADJUST_SIZE(35*2), XX_ADJUST_SIZE(115))];
        descLabel.font = XX_SYSTEM_FONT(40);
        descLabel.textColor = UIColorFromString(@"222222");
        descLabel.numberOfLines = 2;
        [backView addSubview:self.descLabel=descLabel];
        
        CGFloat labelOriginY = descLabel.bottom+XX_ADJUST_SIZE(35);
        CGFloat labelOriginX = XX_ADJUST_SIZE(35);
        for (int i = 0; i < 3; i++) {
            LLMovieLabel *label = [LLMovieLabel ll_movieLabelWithOrigin:CGPointMake(labelOriginX, labelOriginY)];
            [backView addSubview:label];
            [self.typeLabels addObject:label];
            labelOriginX += (label.width+XX_ADJUST_SIZE(35));
        }
        
        UILabel *flowLabel = [[UILabel alloc] initWithFrame:CGRectMake(backView.width-XX_ADJUST_SIZE(200+35), descLabel.bottom + XX_ADJUST_SIZE(43), XX_ADJUST_SIZE(200), XX_ADJUST_SIZE(49))];
        flowLabel.font = XX_SYSTEM_FONT(35);
        flowLabel.textColor = UIColorFromString(@"999999");
        flowLabel.textAlignment = NSTextAlignmentRight;
        [backView addSubview:self.flowLabel=flowLabel];
        
        UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        actionButton.frame = CGRectMake(backView.width-XX_ADJUST_SIZE(104+23), XX_ADJUST_SIZE(43), XX_ADJUST_SIZE(104), XX_ADJUST_SIZE(115));
        [actionButton addTarget:self action:@selector(xx_contactAction) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:self.actionButton=actionButton];
        
    }
    return self;
}

- (void)setData:(LLMovieModel *)data {
    _data = data;
    [self.iconIV xx_imageWithUrl:data.imageUrl];
    self.titleLabel.text = data.title;
    self.scoreView.currentStarRate = data.score;
    
    {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = XX_ADJUST_SIZE(10);
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:data.desc attributes:@{
            NSFontAttributeName: XX_SYSTEM_FONT(40),
            NSParagraphStyleAttributeName: style,
        }];
        self.descLabel.attributedText = attr;
    }
    
    self.flowLabel.text = [NSString stringWithFormat:@"%d想看", (int)data.flowWill];
    self.descLabel.height = data.ll_contentHeight;
    
    CGFloat labelTop = self.descLabel.bottom+XX_ADJUST_SIZE(35);
    for (int i = 0; i < 3; i++) {
        LLMovieLabel *label = self.typeLabels[i];
        if (i >= data.labelList.count) {
            label.hidden = YES;
            continue;
        }
        label.hidden = NO;
        label.text = data.labelList[i];
        label.top = labelTop;
    }
    
    self.flowLabel.top = self.descLabel.bottom + XX_ADJUST_SIZE(43);
    
    self.backView.height = XX_ADJUST_SIZE(461-115) + data.ll_contentHeight;
    {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        CornerRadii cornerRadii = CornerRadiiMake(0, 0, XX_ADJUST_SIZE(23), XX_ADJUST_SIZE(23));
        CGPathRef path = XXPathCreateWithRect(self.backView.bounds, cornerRadii);
        shapeLayer.path = path;
        CGPathRelease(path);
        self.backView.layer.mask = shapeLayer;
    }
    
    [self.actionButton setImage:[UIImage imageNamed:data.hasFlowWill && [LLUserManager isLogin]?@"ll_home_action_1":@"ll_home_action_0"] forState:UIControlStateNormal];
}

- (void)xx_contactAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recommendCellDidClickActionButton:)]) {
        [self.delegate recommendCellDidClickActionButton:self];
    }
}

@end
