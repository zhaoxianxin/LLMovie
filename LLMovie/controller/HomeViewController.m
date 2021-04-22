//
//  HomeViewController.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/12.
//

#import "HomeViewController.h"
#import "LLHomeView.h"

@interface HomeViewController ()
@property (nonatomic, strong) LLHomeView *homeView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"首页" showBack:NO];
    
    LLHomeView *homeView = [[LLHomeView alloc] initWithFrame:CGRectMake(0, XX_NAVIGATION_HEIGHT, self.view.width, XX_SCREEN_HEIGHT-XX_TABBAR_HEIGHT-XX_NAVIGATION_HEIGHT)];
    [self.view addSubview:self.homeView=homeView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ll_didLogin) name:XXUserDidLoginNotifation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ll_didLoginOut) name:XXUserDidLoginOutNotifation object:nil];
    
}

- (void)ll_didLogin {
    [self.homeView ll_update];
}

- (void)ll_didLoginOut {
    [self.homeView ll_update];
}

@end
