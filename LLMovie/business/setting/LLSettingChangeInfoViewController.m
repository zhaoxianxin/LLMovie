//
//  LLSettingChangeInfoViewController.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/16.
//

#import "LLSettingChangeInfoViewController.h"

@interface LLSettingChangeInfoViewController ()
@property (nonatomic, strong) UITextField *textInput;
@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, copy) NSString *changeName;
@property (nonatomic, copy) NSString *oldName;
@property (nonatomic, copy) NSString *oldImage;
@property (nonatomic, copy) NSString *changeImage;
@property (nonatomic, strong) NSMutableArray *randList;
@end

@implementation LLSettingChangeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"设置" showBack:YES];
    
    //加载31个随机头像
    self.randList = [NSMutableArray array];
    for (int i = 1; i < 32; i++) {
        NSString *tempName = [NSString stringWithFormat:@"xx_rand_header_%d@3x", i];
        [self.randList addObject:tempName];
    }
    
    self.oldImage = [LLUserManager loginImage];
    self.oldName = [LLUserManager loginNick];
    self.changeName = self.oldName;
    self.changeImage = self.oldImage;
    
    [self.naView setRightTitle:@"保存" color:UIColorFromString(@"FC7C4F") frame:CGRectMake(XX_SCREEN_WIDTH-XX_ADJUST_SIZE(172), self.naView.height-XX_ADJUST_SIZE(118), XX_ADJUST_SIZE(172), XX_ADJUST_SIZE(118))];
    
    CGFloat top = XX_NAVIGATION_HEIGHT;
    top += XX_ADJUST_SIZE(86);
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width-XX_ADJUST_SIZE(403))/2, top, XX_ADJUST_SIZE(403), XX_ADJUST_SIZE(403))];
        imageView.userInteractionEnabled = YES;
        imageView.layer.cornerRadius = imageView.height/2;
        imageView.layer.masksToBounds = YES;
        [imageView xx_imageWithUrl:self.changeImage];
        [self.view addSubview:self.headerIV=imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ll_headerTaped)];
        [imageView addGestureRecognizer:tap];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(imageView.right-XX_ADJUST_SIZE(86+20), imageView.bottom-XX_ADJUST_SIZE(86+3), XX_ADJUST_SIZE(86), XX_ADJUST_SIZE(86));
        [button setImage:[UIImage imageNamed:@"ll_setting_header_refresh"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(ll_refreshClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        top += imageView.height;
    }
    
    top += XX_ADJUST_SIZE(173);
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(43), top-XX_LINE_SIZE, self.view.width-XX_ADJUST_SIZE(43*2), XX_LINE_SIZE)];
        lineView.backgroundColor = UIColorFromString(@"F0F0F0");
        [self.view addSubview:lineView];
    }
    
    {
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(43), top, XX_ADJUST_SIZE(239-43), XX_ADJUST_SIZE(161))];
        tipLabel.textColor = UIColorFromString(@"222222");
        tipLabel.font = XX_SYSTEM_FONT(46);
        tipLabel.text = @"昵称：";
        [self.view addSubview:tipLabel];
        
        UITextField *textInput = [[UITextField alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(239), top, self.view.width-tipLabel.right-XX_ADJUST_SIZE(43), tipLabel.height)];
        textInput.placeholder = @"请输入昵称";
        textInput.textColor = UIColorFromString(@"222222");
        textInput.font = XX_SYSTEM_FONT(46);
        textInput.text = self.changeName;
        [textInput addTarget:self action:@selector(xx_textValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:self.textInput=textInput];
        
    }
    
}

- (void)ll_refreshClicked {
    int count = (int)self.randList.count;
    int i = arc4random() % count;
    NSString *tempName = self.randList[i];
    self.changeImage = tempName;
    [self.headerIV xx_imageWithUrl:tempName];
}

- (void)ll_headerTaped {
    [self ll_refreshClicked];
}

- (void)xx_textValueChanged:(UITextField *)sender {
    self.changeName = sender.text;
}

- (void)rightClick {
    if (self.changeName.length == 0 || [self.changeName isEqualToString:self.oldName]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [JKAlert alertText:@"保存成功"];
    [LLUserManager saveNick:self.changeName];
    [LLUserManager saveImage:self.changeImage];
    
    if (self.ChangeCallback) {
        self.ChangeCallback(@{
            @"name":self.changeName,
            @"image":self.changeImage
        });
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:XXUserInfoDidChangeNotifation object:nil userInfo:@{
        @"name":self.changeName,
        @"image":self.changeImage
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backClick {
    BOOL infoChanged = (self.changeName.length > 0 && ![self.changeName isEqualToString:self.oldName]) || ![self.changeImage isEqualToString:self.oldImage];
    
    if (infoChanged) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确认要放弃编辑吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [super backClick];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertVC animated:YES completion:NULL];
    } else {
        [super backClick];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:NO];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
