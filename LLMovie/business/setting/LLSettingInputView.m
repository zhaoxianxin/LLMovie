//
//  LLSettingInputView.m
//  LLMovie
//
//  Created by xin xian on 2021/3/25.
//

#import "LLSettingInputView.h"

@interface LLSettingInputView()
@property (nonatomic, assign) int timeCount;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation LLSettingInputView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UITextField *textInput = [[UITextField alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(43), 0, self.width-XX_ADJUST_SIZE(288+43), self.height)];
        textInput.textColor = UIColorFromString(@"222222");
        textInput.font = XX_SYSTEM_FONT(40);
        [self addSubview:self.textInput=textInput];
        
        UIButton *codeButton = [[UIButton alloc] initWithFrame:CGRectMake(XX_SCREEN_WIDTH-XX_ADJUST_SIZE(288), 0, XX_ADJUST_SIZE(288), self.height)];
        [codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [codeButton setTitleColor:UIColorFromString(@"FC7C4F") forState:UIControlStateNormal];
        codeButton.titleLabel.font = XX_SYSTEM_FONT(40);
        codeButton.hidden = YES;
        [self addSubview:self.codeButton=codeButton];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(43), self.height-XX_LINE_SIZE, XX_SCREEN_WIDTH-XX_ADJUST_SIZE(43*2), XX_LINE_SIZE)];
        lineView.backgroundColor = UIColorFromString(@"DEDEDE");
        [self addSubview:self.lineView=lineView];
        
        self.timeCount = 60;
    }
    return self;
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
