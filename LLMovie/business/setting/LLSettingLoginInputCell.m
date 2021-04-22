//
//  LLSettingLoginInputCell.m
//  LLMovie
//
//  Created by xin xian on 2021/3/16.
//

#import "LLSettingLoginInputCell.h"

@interface LLSettingLoginInputCell()
@property (nonatomic, assign) BOOL userCodeButton;
@property (nonatomic, assign) int timeCount;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIView *rightView;
@end

@implementation LLSettingLoginInputCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UITextField *textInput = [[UITextField alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(29), 0, self.width-XX_ADJUST_SIZE(29*2), self.height)];
        textInput.textColor = UIColorFromString(@"333333");
        textInput.font = XX_SYSTEM_FONT(35);
        textInput.layer.backgroundColor = [UIColorFromString(@"EAEAEA") CGColor];
        textInput.layer.cornerRadius = textInput.height/2;
        textInput.layer.masksToBounds = YES;
        textInput.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XX_ADJUST_SIZE(43), self.height)];
        textInput.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:self.textInput=textInput];
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XX_ADJUST_SIZE(300), self.height)];
        UIButton *codeButton = [[UIButton alloc] initWithFrame:rightView.bounds];
        [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [codeButton setTitleColor:UIColorFromString(@"999999") forState:UIControlStateNormal];
        codeButton.titleLabel.font = XX_SYSTEM_FONT(35);
        [rightView addSubview:self.codeButton = codeButton];
        self.rightView = rightView;
        
    }
    return self;
}

- (void)showCodeButton {
    self.timeCount = 60;
    self.userCodeButton = YES;
    self.textInput.rightView = self.rightView;
    self.textInput.rightViewMode = UITextFieldViewModeAlways;
}

- (void)startTimer {
    self.codeButton.userInteractionEnabled = NO;
    [self.codeButton setTitle:[NSString stringWithFormat:@"%ds", self.timeCount] forState:UIControlStateNormal];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timeCount = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(xx_timerAction:) userInfo:nil repeats:YES];
}

- (void)xx_timerAction:(NSTimer *)sender {
    self.timeCount--;
    if (self.timeCount <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        [self.codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
        self.codeButton.userInteractionEnabled = YES;
    } else {
        [self.codeButton setTitle:[NSString stringWithFormat:@"%ds", self.timeCount] forState:UIControlStateNormal];
    }
}

- (void)endTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (!self.codeButton.userInteractionEnabled) {
        [self.codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
    }
    self.codeButton.userInteractionEnabled = YES;
}

@end
