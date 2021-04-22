//
//  LLSettingPWDLoginViewController.m
//  LLMovie
//
//  Created by xin xian on 2021/3/16.
//

#import "LLSettingPWDLoginViewController.h"
#import "LLSettingCodeLoginViewController.h"
#import "LLSettingFindPwdNextViewController.h"

@interface LLSettingPWDLoginViewController ()
@property (nonatomic, strong) UITextField *phoneCell;
@property (nonatomic, strong) UITextField *passwordCell;
@end

@implementation LLSettingPWDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"" showBack:YES];
    self.naView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = UIColorFromString(@"F0F0F0");
    
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
        titleLabel.text = @"密码登陆";
        [self.view addSubview:titleLabel];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.bottom + XX_ADJUST_SIZE(17), self.view.width, XX_ADJUST_SIZE(58))];
        tipLabel.textColor = UIColorFromString(@"AAAAAA");
        tipLabel.font = XX_SYSTEM_FONT(40);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"未注册的手机通过验证码登录自动注册";
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
        passwordCell.placeholder = @"请输入密码";
        passwordCell.textColor = UIColorFromString(@"222222");
        passwordCell.font = XX_SYSTEM_FONT(40);
        passwordCell.keyboardType = UIKeyboardTypePhonePad;
        passwordCell.secureTextEntry = YES;
        [backView addSubview:self.passwordCell=passwordCell];
        
        {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, passwordCell.height-XX_LINE_SIZE, passwordCell.width, XX_LINE_SIZE)];
            lineView.backgroundColor = UIColorFromString(@"DEDEDE");
            [passwordCell addSubview:lineView];
        }
        
        UIButton *codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        codeButton.frame = CGRectMake(0, passwordCell.bottom, XX_ADJUST_SIZE(202+58*2), XX_ADJUST_SIZE(112));
        codeButton.titleLabel.font = XX_SYSTEM_FONT(40);
        [codeButton setTitle:@"验证码登陆" forState:UIControlStateNormal];
        [codeButton setTitleColor:UIColorFromString(@"252525") forState:UIControlStateNormal];
        [codeButton addTarget:self action:@selector(xx_clickCodeButton) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:codeButton];
        
        UIButton *findpwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        findpwdButton.frame = CGRectMake(backView.width-XX_ADJUST_SIZE(202+58*2), passwordCell.bottom, XX_ADJUST_SIZE(202+58*2), XX_ADJUST_SIZE(112));
        findpwdButton.titleLabel.font = XX_SYSTEM_FONT(40);
        [findpwdButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [findpwdButton setTitleColor:UIColorFromString(@"252525") forState:UIControlStateNormal];
        [findpwdButton addTarget:self action:@selector(xx_clickFindPassword) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:findpwdButton];
        
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake((backView.width - XX_ADJUST_SIZE(346)) / 2, passwordCell.bottom + XX_ADJUST_SIZE(147), XX_ADJUST_SIZE(346), XX_ADJUST_SIZE(127));
        loginButton.layer.cornerRadius = loginButton.height/2;
        loginButton.layer.masksToBounds = YES;
        loginButton.layer.backgroundColor = [UIColorFromString(@"252525") CGColor];
        loginButton.titleLabel.font = XX_SYSTEM_FONT(43);
        [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(ll_clickLogin) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:loginButton];
        
    }
    
    
    {
        NSString *fullStr = @"登录即代表您同意《用户协议》、《隐私政策》";
        NSString *protStr = @"《用户协议》、《隐私政策》";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:fullStr];
        [attr addAttributes:@{
            NSForegroundColorAttributeName:UIColorFromString(@"FC7C4F"),
        } range:[fullStr rangeOfString:protStr]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, top, self.view.width, XX_ADJUST_SIZE(136))];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromString(@"333333");
        label.font = XX_SYSTEM_FONT(37);
        label.attributedText = attr;
        [label sizeToFit];
        label.height = XX_ADJUST_SIZE(136);
        label.centerX = self.view.width/2;
        [self.view addSubview:label];
        
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.frame = label.frame;
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(xx_clickProtocol) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:sendButton];
    }
    
}

- (void)xx_clickCodeButton {
    LLSettingCodeLoginViewController *codeLogin = [[LLSettingCodeLoginViewController alloc] init];
    [self.navigationController pushViewController:codeLogin animated:YES];
}

- (void)xx_clickProtocol {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"《用户协议》" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[LLRouterManager shareInstance] ll_routeUrl:@"xx://my_protocol" obj:@{
            @"showName": @"用户协议",
            @"fileName": XX_PROTOCOL_REGEIST_LINK,
        }];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"《隐私政策》" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[LLRouterManager shareInstance] ll_routeUrl:@"xx://my_protocol" obj:@{
            @"showName": @"隐私政策",
            @"fileName": XX_PROTOCOL_PRIVACY_LINK,
        }];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:NULL];
}

- (void)ll_clickLogin {
    if (self.phoneCell.text.length == 0) {
        [JKAlert alertText:@"请先输入手机号"];
        return;
    }
    if (![self.phoneCell.text xx_isPhoneNumber]) {
        [JKAlert alertText:@"手机号格式不正确！"];
        return;
    }
    if (self.passwordCell.text.length == 0) {
        [JKAlert alertText:@"请输入密码"];
        return;
    }
    //匹配测试服账号+密码
    if (![self.phoneCell.text hasPrefix:XX_LOGIN_TEST_NAME_PRE] || [self.passwordCell.text length] != 6) {
        [JKAlert alertText:@"用户名或密码输入错误！"];
        return;
    }
    [JKAlert alertWaitingText:@"登陆中..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JKAlert alertWaiting:NO];
        [LLUserManager loginWithUser:self.phoneCell.text];
    });
}

- (void)xx_clickFindPassword {
    LLSettingFindPwdNextViewController *findLogin = [[LLSettingFindPwdNextViewController alloc] init];
    [self.navigationController pushViewController:findLogin animated:YES];
}

- (void)backClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:NO];
}

@end
