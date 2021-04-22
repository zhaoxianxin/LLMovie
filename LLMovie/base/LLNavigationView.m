//
//  LLNavigationView.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/12.
//

#import "LLNavigationView.h"

@interface LLNavigationView()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong, readwrite) UIButton *backButton;
@property (nonatomic, strong, readwrite) UIButton *rightButton;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation LLNavigationView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromString(@"222222");
        label.font = XX_SYSTEM_FONT(49);
        [self addSubview:self.label=label];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(XX_ADJUST_SIZE(14), self.height - XX_ADJUST_SIZE(127), XX_ADJUST_SIZE(127), XX_ADJUST_SIZE(127));
        [self addSubview:self.backButton=backButton];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(self.width-XX_ADJUST_SIZE(127), self.height - XX_ADJUST_SIZE(127), XX_ADJUST_SIZE(127), XX_ADJUST_SIZE(127));
        rightButton.hidden = YES;
        rightButton.titleLabel.font = XX_SYSTEM_FONT(40);
        [self addSubview:self.rightButton=rightButton];
        
        [self setIsHighlighted:NO];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-XX_LINE_SIZE, self.width, XX_LINE_SIZE)];
        lineView.backgroundColor = UIColorFromString(@"EAEAEA");
        lineView.hidden = YES;
        [self addSubview:self.lineView=lineView];
    }
    return self;
}

- (void)setShowLine:(BOOL)showLine {
    _showLine = showLine;
    self.lineView.hidden = !showLine;
}

- (void)setTitle:(NSString *)title {
    self.label.text = title;
    [self.label sizeToFit];
    self.label.centerX = self.width/2;
    self.label.bottom = self.height-XX_ADJUST_SIZE(29);
}

- (void)hideBack {
    self.backButton.hidden = YES;
}

- (void)setIsHighlighted:(BOOL)isHighlighted {
    _isHighlighted = isHighlighted;
    if (isHighlighted) {
        [self.backButton setImage:[UIImage imageNamed:@"ll_home_nav_white"] forState:UIControlStateNormal];
    } else {
        [self.backButton setImage:[UIImage imageNamed:@"ll_home_nav_black"] forState:UIControlStateNormal];
    }
}

- (void)setRightImage:(UIImage *)image {
    [self.rightButton setImage:image forState:UIControlStateNormal];
    self.rightButton.hidden = image == nil;
}

- (void)setRightTitle:(NSString *)title color:(UIColor *)color frame:(CGRect)frame {
    [self.rightButton setTitle:title forState:UIControlStateNormal];
    [self.rightButton setTitleColor:color forState:UIControlStateNormal];
    self.rightButton.frame = frame;
    self.rightButton.hidden = title.length == 0;
}

@end
