//
//  LLBaseViewController.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/12.
//

#import "LLBaseViewController.h"

@interface LLBaseViewController () <UIGestureRecognizerDelegate>
@property(nonatomic, strong, readwrite) LLNavigationView *naView;

@property (nonatomic, strong) UIView *nothingView;

@end

@implementation LLBaseViewController

- (void)dealloc {
    NSLog(@"[%@] -- dealloc", NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    if ([self supportGesturesToBack]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    LLNavigationView *naView = [[LLNavigationView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, XX_NAVIGATION_HEIGHT)];
    [naView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [naView.rightButton addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.naView=naView];
}

- (void)setNavTitle:(NSString *)title {
    [self setNavTitle:title showBack:YES];
}

- (void)setNavTitle:(NSString *)title showBack:(BOOL)showBack {
    [self.naView setTitle:title];
    self.naView.backButton.hidden = !showBack;
}

- (UIView *)nothingView {
    if (!_nothingView) {
        UIView *nothingView = [[UIView alloc] initWithFrame:CGRectMake(0, XX_NAVIGATION_HEIGHT, self.view.width, XX_SCREEN_HEIGHT-XX_SAFE_BOTTOM-XX_NAVIGATION_HEIGHT)];
        nothingView.backgroundColor = [UIColor whiteColor];
        nothingView.hidden = YES;
        [self.view addSubview:_nothingView=nothingView];
        
        CGFloat top = XX_NAVIGATION_HEIGHT;
        top += XX_ADJUST_SIZE(380);
        
        CGSize imageSize = [self nothingImageSize];
        UIImageView *imageIV = [[UIImageView alloc] initWithFrame:CGRectMake((nothingView.width-imageSize.width)/2, top, imageSize.width, imageSize.height)];
        imageIV.tag = 1000;
        imageIV.image = [UIImage imageNamed:[self nothingImage]];
        [nothingView addSubview:imageIV];
        
        top += imageSize.height;
        
        NSString *nothingText = [self nothingText];
        if (nothingText.length > 0) {
            top += XX_ADJUST_SIZE(72);
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(nothingView.width/4, top, nothingView.width/2, XX_ADJUST_SIZE(60))];
            label.font = XX_SYSTEM_FONT(43);
            label.textColor = UIColorFromString(@"AAAAAA");
            label.textAlignment = NSTextAlignmentCenter;
            label.text = nothingText;
            [nothingView addSubview:label];
            
            top += label.height;
            top += XX_ADJUST_SIZE(29);
        }
        
        top += XX_ADJUST_SIZE(92);
        
        UIButton *button = [self nothingButton];
        if (button) {
            button.top = top;
            button.centerX = nothingView.width/2;
            [nothingView addSubview:button];
        }
        
    }
    
    return _nothingView;
}

- (void)setShowNothingView:(BOOL)show {
    self.nothingView.hidden = !show;
    if (show) {
        [self.view bringSubviewToFront:self.nothingView];
    } else {
        [self.view sendSubviewToBack:self.nothingView];
    }
}

- (NSString *)nothingText {
    return @"";
}

- (CGSize)nothingImageSize {
    return CGSizeMake(XX_ADJUST_SIZE(374), XX_ADJUST_SIZE(478));
}

- (NSString *)nothingImage {
    return @"";
}

- (UIButton *)nothingButton {
    return nil;
}

- (BOOL)supportGesturesToBack {
    return YES;
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightClick {
    
}

@end
