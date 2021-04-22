//
//  AppDelegate.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/12.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "CircleViewController.h"
#import "MyViewController.h"
#import "LLBusinessRouteService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [LLBusinessRouteService ll_registService];
    [LLShareDataCache ll_registCache];
    
    
    UITabBarController *barVC = [[UITabBarController alloc] init];
    NSMutableArray *vcs = [NSMutableArray array];
    {
        HomeViewController *vc = [HomeViewController new];
        vc.tabBarItem.title = @"推荐";
        vc.tabBarItem.image = [UIImage imageNamed:@"ll_tab_icon_1"];
        [vcs addObject:vc];
    }
    {
        CircleViewController *vc = [CircleViewController new];
        vc.tabBarItem.title = @"发现";
        vc.tabBarItem.image = [UIImage imageNamed:@"ll_tab_icon_2"];
        [vcs addObject:vc];
    }
    {
        MyViewController *vc = [MyViewController new];
        vc.tabBarItem.title = @"我的";
        vc.tabBarItem.image = [UIImage imageNamed:@"ll_tab_icon_3"];
        [vcs addObject:vc];
    }
    barVC.tabBar.tintColor = UIColorFromString(@"222222");
    barVC.viewControllers = vcs;
    
    self.naVC = [[UINavigationController alloc] initWithRootViewController:barVC];
    self.naVC.navigationBar.hidden = YES;
    self.window.rootViewController = self.naVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
