//
//  LLSettingVerifyNextViewController.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/16.
//

#import "LLSettingVerifyNextViewController.h"
#import "LLSettingInputView.h"

@interface LLSettingVerifyNextViewController ()
@property (nonatomic, strong) LLSettingInputView *phoneCell;
@property (nonatomic, strong) LLSettingInputView *codeCell;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, assign) BOOL hasSendCode;
@end

@implementation LLSettingVerifyNextViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.phoneCell endTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"修改登陆密码" showBack:YES];
    
    CGFloat top = XX_NAVIGATION_HEIGHT+XX_ADJUST_SIZE(43);
    CGFloat cellHeight = XX_ADJUST_SIZE(156);
    
    {
        LLSettingInputView *cell = [[LLSettingInputView alloc] initWithFrame:CGRectMake(0, top, self.view.width, cellHeight)];
        cell.textInput.placeholder = @"请输入您的手机号";
        cell.textInput.keyboardType = UIKeyboardTypePhonePad;
        [self.view addSubview:self.phoneCell=cell];
        top += cell.height;
    }
    
    {
        LLSettingInputView *cell = [[LLSettingInputView alloc] initWithFrame:CGRectMake(0, top, self.view.width, cellHeight)];
        cell.textInput.placeholder = @"请输入验证码";
        cell.codeButton.hidden = NO;
        [cell.codeButton addTarget:self action:@selector(ll_clickCodeButton) forControlEvents:UIControlEventTouchUpInside];
        cell.textInput.keyboardType = UIKeyboardTypePhonePad;
        [self.view addSubview:self.codeCell=cell];
        top += cell.height;
    }
    
    top += XX_ADJUST_SIZE(147);
    {
        
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.frame = CGRectMake((self.view.width - XX_ADJUST_SIZE(346)) / 2, top, XX_ADJUST_SIZE(346), XX_ADJUST_SIZE(127));
        sendButton.layer.cornerRadius = sendButton.height/2;
        sendButton.layer.masksToBounds = YES;
        sendButton.layer.backgroundColor = [UIColorFromString(@"252525") CGColor];
        sendButton.titleLabel.font = XX_SYSTEM_FONT(43);
        [sendButton setTitle:@"下一步" forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(ll_clickNext) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.confirmButton=sendButton];
    }
    
}

- (void)backClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)ll_clickCodeButton {
    if (self.phoneCell.textInput.text.length == 0) {
        [JKAlert alertText:@"请先输入手机号"];
        return;
    }
    if (![self.phoneCell.textInput.text xx_isPhoneNumber]) {
        [JKAlert alertText:@"手机号格式不正确！"];
        return;
    }
    [JKAlert alertText:@"验证码已发送"];
    self.hasSendCode = YES;
    [self.codeCell startTimer];
}

- (void)ll_clickNext {
    if (self.phoneCell.textInput.text.length == 0) {
        [JKAlert alertText:@"请先输入手机号"];
        return;
    }
    if (![self.phoneCell.textInput.text xx_isPhoneNumber]) {
        [JKAlert alertText:@"手机号格式不正确！"];
        return;
    }
    if (!self.hasSendCode) {
        [JKAlert alertText:@"请先发送验证码"];
        return;
    }
    if (self.codeCell.textInput.text.length == 0) {
        [JKAlert alertText:@"请先输入验证码"];
        return;
    }
    if (![self.codeCell.textInput.text xx_isNumber]) {
        [JKAlert alertText:@"验证码格式不正确"];
        return;
    }
    
    //匹配测试服验证码
    if (![self.codeCell.textInput.text isEqualToString:XX_LOGIN_TEST_CODE]) {
        [JKAlert alertText:@"验证码输入错误！"];
        return;
    }
    
    //跳转到修改密码
    [[LLRouterManager shareInstance] ll_routeUrl:@"xx://setting_changePassword" obj:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:NO];
}

@end
