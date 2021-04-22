//
//  LLDetailInputView.m
//  LLMovie
//
//  Created by xin xian on 2021/3/23.
//

#import "LLDetailInputView.h"

@implementation LLDetailInputView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        //底部输入框
        {
            UITextField *bottomInput = [[UITextField alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(43), XX_ADJUST_SIZE(23), self.width-XX_ADJUST_SIZE(178+43), XX_ADJUST_SIZE(115))];
            bottomInput.layer.cornerRadius = bottomInput.height/2;
            bottomInput.layer.backgroundColor = [UIColorFromString(@"F0F0F0") CGColor];
            bottomInput.layer.masksToBounds = YES;
            bottomInput.textColor = UIColorFromString(@"222222");
            bottomInput.font = XX_SYSTEM_FONT(40);
            bottomInput.placeholder = @"我来说几句";
            bottomInput.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XX_ADJUST_SIZE(46), bottomInput.height)];
            bottomInput.leftViewMode = UITextFieldViewModeAlways;
            [self addSubview:self.bottomInput=bottomInput];
            
            {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(self.width - XX_ADJUST_SIZE(178), 0, XX_ADJUST_SIZE(178), XX_ADJUST_SIZE(115+23*2));
                button.titleLabel.font = XX_SYSTEM_FONT(46);
                [button setTitle:@"发送" forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromString(@"FC7C4F") forState:UIControlStateNormal];
                [self addSubview:self.sendButton=button];
            }
            
        }
        
    }
    return self;
}

@end
