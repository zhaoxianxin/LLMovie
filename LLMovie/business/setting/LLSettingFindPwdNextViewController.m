//
//  LLSettingFindPwdNextViewController.m
//  LLMovie
//
//  Created by xin xian on 2021/3/25.
//

#import "LLSettingFindPwdNextViewController.h"

@interface LLSettingFindPwdNextViewController ()
@property (nonatomic, assign) BOOL hasSendCode;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UITextField *phoneCell;
@property (nonatomic, strong) UITextField *codeCell;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, assign) NSInteger timeCount;
@end

@implementation LLSettingFindPwdNextViewController

- (BOOL)supportGesturesToBack {
    return NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self ll_endTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"" showBack:YES];
    self.naView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = UIColorFromString(@"F0F0F0");
    self.timeCount = 60;
    
    [self ll_createViews];
    
}

- (void)ll_createViews {
    CGFloat top = XX_NAVIGATION_HEIGHT;
    top += XX_ADJUST_SIZE(43);
    
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(XX_SCREEN_WIDTH/4, top, XX_SCREEN_WIDTH/2, XX_ADJUST_SIZE(107))];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = UIColorFromString(@"222222");
        titleLabel.font = XX_SYSTEM_FONT(75);
        titleLabel.text = @"找回密码";
        [self.view addSubview:titleLabel];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.bottom + XX_ADJUST_SIZE(17), self.view.width, XX_ADJUST_SIZE(58))];
        tipLabel.textColor = UIColorFromString(@"AAAAAA");
        tipLabel.font = XX_SYSTEM_FONT(40);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"通过手机验证码找回";
        [self.view addSubview:tipLabel];
        
        top = tipLabel.bottom;
    }
    
    top += XX_ADJUST_SIZE(43);
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(43), top, self.view.width-XX_ADJUST_SIZE(43*2), XX_ADJUST_SIZE(691))];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = XX_ADJUST_SIZE(23);
    backView.layer.masksToBounds = YES;
    [self.view addSubview:backView];
    top += backView.height;
    
    {
        UITextField *phoneCell = [[UITextField alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(58), XX_ADJUST_SIZE(14), backView.width-XX_ADJUST_SIZE(58*2), XX_ADJUST_SIZE(156))];
        phoneCell.placeholder = @"请输入您的手机号";
        phoneCell.textColor = UIColorFromString(@"222222");
        phoneCell.font = XX_SYSTEM_FONT(40);
        phoneCell.keyboardType = UIKeyboardTypePhonePad;
        [backView addSubview:self.phoneCell=phoneCell];
        
        {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, phoneCell.height-XX_LINE_SIZE, phoneCell.width, XX_LINE_SIZE)];
            lineView.backgroundColor = UIColorFromString(@"DEDEDE");
            [phoneCell addSubview:lineView];
        }
        
        UITextField *passwordCell = [[UITextField alloc] initWithFrame:CGRectMake(phoneCell.left, phoneCell.bottom, phoneCell.width, phoneCell.height)];
        passwordCell.placeholder = @"请输入验证码";
        passwordCell.textColor = UIColorFromString(@"222222");
        passwordCell.font = XX_SYSTEM_FONT(40);
        passwordCell.keyboardType = UIKeyboardTypePhonePad;
        [backView addSubview:self.codeCell=passwordCell];
        
        {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, passwordCell.height-XX_LINE_SIZE, passwordCell.width, XX_LINE_SIZE)];
            lineView.backgroundColor = UIColorFromString(@"DEDEDE");
            [passwordCell addSubview:lineView];
            
            UIButton *codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            codeButton.frame = CGRectMake(backView.width-XX_ADJUST_SIZE(318), passwordCell.top, XX_ADJUST_SIZE(318), passwordCell.height);
            codeButton.titleLabel.font = XX_SYSTEM_FONT(40);
            [codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
            [codeButton setTitleColor:UIColorFromString(@"FC7C4F") forState:UIControlStateNormal];
            [codeButton addTarget:self action:@selector(xx_clickSendCode) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:self.codeButton=codeButton];
        }
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake((backView.width - XX_ADJUST_SIZE(346)) / 2, passwordCell.bottom + XX_ADJUST_SIZE(147), XX_ADJUST_SIZE(346), XX_ADJUST_SIZE(127));
        loginButton.layer.cornerRadius = loginButton.height/2;
        loginButton.layer.masksToBounds = YES;
        loginButton.layer.backgroundColor = [UIColorFromString(@"252525") CGColor];
        loginButton.titleLabel.font = XX_SYSTEM_FONT(43);
        [loginButton setTitle:@"下一步" forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(ll_clickNext) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:loginButton];
        
    }
    
}

- (void)xx_clickSendCode {
    self.hasSendCode = YES;
    self.codeButton.userInteractionEnabled = NO;
    [self.codeButton setTitle:[NSString stringWithFormat:@"%ds", (int)self.timeCount] forState:UIControlStateNormal];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timeCount = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ll_timerAction:) userInfo:nil repeats:YES];
}

- (void)ll_timerAction:(NSTimer *)sender {
    self.timeCount--;
    if (self.timeCount <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        [self.codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
        self.codeButton.userInteractionEnabled = YES;
    } else {
        [self.codeButton setTitle:[NSString stringWithFormat:@"%ds", (int)self.timeCount] forState:UIControlStateNormal];
    }
}

- (void)ll_endTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (!self.codeButton.userInteractionEnabled) {
        [self.codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
    }
    self.codeButton.userInteractionEnabled = YES;
}

- (void)ll_clickNext {
    if (self.phoneCell.text.length == 0) {
        [JKAlert alertText:@"请先输入手机号"];
        return;
    }
    if (![self.phoneCell.text xx_isPhoneNumber]) {
        [JKAlert alertText:@"手机号格式不正确！"];
        return;
    }
    if (!self.hasSendCode) {
        [JKAlert alertText:@"请先发送验证码"];
        return;
    }
    if (self.codeCell.text.length == 0) {
        [JKAlert alertText:@"请先输入验证码"];
        return;
    }
    if (![self.codeCell.text xx_isNumber]) {
        [JKAlert alertText:@"验证码格式不正确"];
        return;
    }
    
    //匹配测试服验证码
    if (![self.codeCell.text isEqualToString:XX_LOGIN_TEST_CODE]) {
        [JKAlert alertText:@"验证码输入错误！"];
        return;
    }
    
    //跳转到设置密码、并登陆
    [[LLRouterManager shareInstance] ll_routeUrl:@"xx://setting_changePassword" obj:@{
        @"isLogin": @YES,
        @"phoneNum": self.phoneCell.text,
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:NO];
}

@end
