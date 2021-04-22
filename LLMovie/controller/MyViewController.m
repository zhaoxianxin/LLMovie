//
//  MyViewController.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/12.
//

#import "MyViewController.h"
#import "LLMyHomeView.h"

@interface MyViewController ()
@property (nonatomic, strong) LLMyHomeView *homeView;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"" showBack:NO];
    self.naView.hidden = YES;
    
    LLMyHomeView *homeView = [[LLMyHomeView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, XX_SCREEN_HEIGHT-XX_TABBAR_HEIGHT)];
    [self.view addSubview:self.homeView=homeView];
    
    if (@available(iOS 11.0, *)) {
        homeView.ll_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ll_didLogin) name:XXUserDidLoginNotifation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ll_didLoginOut) name:XXUserDidLoginOutNotifation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ll_userInfoDidChange) name:XXUserInfoDidChangeNotifation object:nil];
}

- (void)ll_userInfoDidChange {
    [self.homeView ll_update];
}

- (void)ll_didLogin {
    [self.homeView ll_update];
}

- (void)ll_didLoginOut {
    [self.homeView ll_update];
}

@end
