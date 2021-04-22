//
//  LLSettingSetPasswordViewController.m
//  LLMovie
//
//  Created by xin xian on 2021/3/16.
//

#import "LLSettingSetPasswordViewController.h"
#import "LLSettingInputView.h"

@interface LLSettingSetPasswordViewController ()
@property (nonatomic, strong) LLSettingInputView *firstCell;
@property (nonatomic, strong) LLSettingInputView *secondCell;
@end

@implementation LLSettingSetPasswordViewController

- (BOOL)supportGesturesToBack {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:self.isLogin?@"找回登陆密码":@"修改登陆密码" showBack:YES];
    
    CGFloat top = XX_NAVIGATION_HEIGHT+XX_ADJUST_SIZE(43);
    CGFloat cellHeight = XX_ADJUST_SIZE(156);
    
    {
        LLSettingInputView *cell = [[LLSettingInputView alloc] initWithFrame:CGRectMake(0, top, self.view.width, cellHeight)];
        cell.textInput.placeholder = @"输入密码";
        cell.textInput.keyboardType = UIKeyboardTypePhonePad;
        cell.textInput.secureTextEntry = YES;
        [self.view addSubview:self.firstCell=cell];
        top += cell.height;
    }
    
    {
        LLSettingInputView *cell = [[LLSettingInputView alloc] initWithFrame:CGRectMake(0, top, self.view.width, cellHeight)];
        cell.textInput.placeholder = @"二次输入密码";
        cell.textInput.keyboardType = UIKeyboardTypePhonePad;
        cell.textInput.secureTextEntry = YES;
        [self.view addSubview:self.secondCell=cell];
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
        [sendButton setTitle:self.isLogin?@"登陆":@"保存" forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(ll_clickSave) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:sendButton];
    }
    
}

- (void)ll_clickSave {
    if (self.firstCell.textInput.text.length == 0) {
        [JKAlert alertText:@"请先输入密码"];
        return;
    }
    if (self.firstCell.textInput.text.length < 6 || self.firstCell.textInput.text.length > 16) {
        [JKAlert alertText:@"请输入6-16位密码"];
        return;
    }
    
    if (self.secondCell.textInput.text.length == 0) {
        [JKAlert alertText:@"请二次输入密码"];
        return;
    }
    
    if (![self.firstCell.textInput.text isEqualToString:self.secondCell.textInput.text]) {
        [JKAlert alertText:@"两次输入密码不一致"];
        return;
    }
    
    [JKAlert alertWaitingText:@"请求中..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JKAlert alertWaiting:NO];
        if (self.isLogin) {
            [LLUserManager loginWithUser:self.phoneNum];
        } else {
            [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
        }
    });
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:NO];
}

- (void)backClick {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:self.isLogin?@"确定要放弃找回密码吗？":@"确认要放弃修改吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:NULL];
}

@end
