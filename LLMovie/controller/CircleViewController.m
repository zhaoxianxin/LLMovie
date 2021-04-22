//
//  CircleViewController.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/12.
//

#import "CircleViewController.h"
#import "LLCircleView.h"

@interface CircleViewController ()
@property (nonatomic, strong) LLCircleView *homeView;
@end

@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"动态" showBack:NO];
    
    LLCircleView *homeView = [[LLCircleView alloc] initWithFrame:CGRectMake(0, XX_NAVIGATION_HEIGHT, self.view.width, XX_SCREEN_HEIGHT-XX_TABBAR_HEIGHT-XX_NAVIGATION_HEIGHT)];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
