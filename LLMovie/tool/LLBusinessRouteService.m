//
//  LLBusinessRouteService.m
//  LLMovie
//
//  Created by xin xian on 2021/3/12.
//

#import "LLBusinessRouteService.h"
#import "LLHomeDetailViewController.h"
#import "AppDelegate.h"
#import "LLReportViewController.h"
#import "LLMovieScoreViewController.h"
#import "LLCircleDetailViewController.h"
//#import "LLUserCircleListViewController.h"
#import "LLCirclePublicViewController.h"
#import "LLMyCircleListViewController.h"
#import "LLMyMessageViewController.h"
#import "LLMyMovieWillViewController.h"
#import "LLSettingBlackViewController.h"
#import "LLMyAboutUsViewController.h"
#import "LLMyProtocolViewController.h"
#import "LLHomeSettingViewController.h"
#import "LLSettingChangeInfoViewController.h"
#import "LLSettingVerifyNextViewController.h"
#import "LLSettingSetPasswordViewController.h"
#import "LLSettingPWDLoginViewController.h"

@implementation LLBusinessRouteService
+ (void)ll_registService {
    [[LLRouterManager shareInstance] ll_registUrl:@"xx://home_detail" routeBack:^(id _Nonnull obj, XXDataBack  _Nonnull dataBack) {
        LLHomeDetailViewController *detailVC = [[LLHomeDetailViewController alloc] init];
        detailVC.model = obj;
        detailVC.WillStateChanged = dataBack;
        [[(AppDelegate *)[UIApplication sharedApplication].delegate naVC] pushViewController:detailVC animated:YES];
    }];
    
    [[LLRouterManager shareInstance] ll_registUrl:@"xx://report" routeBack:^(id _Nonnull obj, XXDataBack  _Nonnull dataBack) {
        if (![LLUserManager isLogin]) {
            [LLUserManager ll_showLogin];
            return;
        }
        LLReportViewController *reportVC = [[LLReportViewController alloc] init];
        reportVC.model = obj;
        [[(AppDelegate *)[UIApplication sharedApplication].delegate naVC] pushViewController:reportVC animated:YES];
    }];
    
    [[LLRouterManager shareInstance] ll_registUrl:@"xx://detail_add_score" routeBack:^(id _Nonnull obj, XXDataBack  _Nonnull dataBack) {
        LLMovieScoreViewController *scoreVC = [[LLMovieScoreViewController alloc] init];
        scoreVC.model = obj;
        scoreVC.AddScoreCallBack = dataBack;
        [[(AppDelegate *)[UIApplication sharedApplication].delegate naVC] pushViewController:scoreVC animated:YES];
    }];
    
    [[LLRouterManager shareInstance] ll_registUrl:@"xx://circle_detail" routeBack:^(id _Nonnull obj, XXDataBack  _Nonnull dataBack) {
        LLCircleDetailViewController *detailVC = [[LLCircleDetailViewController alloc] init];
        detailVC.model = obj;
        detailVC.DeleteCallBack = dataBack;
        [[(AppDelegate *)[UIApplication sharedApplication].delegate naVC] pushViewController:detailVC animated:YES];
    }];
//
//    [[LLRouterManager shareInstance] ll_registUrl:@"xx://circle_user_home" routeBack:^(NSDictionary * _Nonnull obj, XXDataBack  _Nonnull dataBack) {
//        LLUserCircleListViewController *detailVC = [[LLUserCircleListViewController alloc] init];
//        detailVC.userName = obj[@"userName"];
//        detailVC.userIcon = obj[@"userIcon"];
//        [[(AppDelegate *)[UIApplication sharedApplication].delegate naVC] pushViewController:detailVC animated:YES];
//    }];
//
    [[LLRouterManager shareInstance] ll_registUrl:@"xx://circle_public" routeBack:^(id _Nonnull obj, XXDataBack  _Nonnull dataBack) {
        LLCirclePublicViewController *pubVC = [[LLCirclePublicViewController alloc] init];
        pubVC.DidPublish = dataBack;
        [[(AppDelegate *)[UIApplication sharedApplication].delegate naVC] pushViewController:pubVC animated:YES];
    }];
    
    [[LLRouterManager shareInstance] ll_registUrl:@"xx://my_circle_list" routeBack:^(id _Nonnull obj, XXDataBack  _Nonnull dataBack) {
        LLMyCircleListViewController *targetVC = [[LLMyCircleListViewController alloc] init];
        [[(AppDelegate *)[UIApplication sharedApplication].delegate naVC] pushViewController:targetVC animated:YES];
    }];
    
    [[LLRouterManager shareInstance] ll_registUrl:@"xx://my_messages" routeBack:^(id _Nonnull obj, XXDataBack  _Nonnull dataBack) {
        LLMyMessageViewController *targetVC = [[LLMyMessageViewController alloc] init];
        [[(AppDelegate *)[UIApplication sharedApplication].delegate naVC] pushViewController:targetVC animated:YES];
    }];
    
    [[LLRouterManager shareInstance] ll_registUrl:@"xx://my_movie_will" routeBack:^(id _Nonnull obj, XXDataBack  _Nonnull dataBack) {
        LLMyMovieWillViewController *targetVC = [[LLMyMovieWillViewController alloc] init];
        [[(AppDelegate *)[UIApplication sharedApplication].delegate naVC] pushViewController:targetVC animated:YES];
    }];
    
    [[LLRouterManager shareInstance] ll_registUrl:@"xx://setting_black" routeBack:^(id _Nonnull obj, XXDataBack  _Nonnull dataBack) {
        LLSettingBlackViewController *targetVC = [[LLSettingBlackViewController alloc] init];
        [[(AppDelegate *)[UIApplication sharedApplication].delegate naVC] pushViewController:targetVC animated:YES];
    }];
    
    [[LLRouterManager shareInstance] ll_registUrl:@"xx://my_aboutus" routeBack:^(id _Nonnull obj, XXDataBack  _Nonnull dataBack) {
        LLMyAboutUsViewController *targetVC = [[LLMyAboutUsViewController alloc] init];
        [[(AppDelegate *)[UIApplication sharedApplication].delegate naVC] pushViewController:targetVC animated:YES];
    }];
    
    [[LLRouterManager shareInstance] ll_registUrl:@"xx://my_protocol" routeBack:^(id _Nonnull obj, XXDataBack  _Nonnull dataBack) {
        LLMyProtocolViewController *targetVC = [[LLMyProtocolViewController alloc] init];
        targetVC.showName = obj[@"showName"];
        targetVC.fileName = obj[@"fileName"];
        //已经弹出一个导航栏了！
        UINavigationController *naVC = [(AppDelegate *)[UIApplication sharedApplication].delegate naVC];
        if (naVC.presentedViewController) {
            naVC = (UINavigationController *)naVC.presentedViewController;
        }
        [naVC pushViewController:targetVC animated:YES];
    }];
    
    [[LLRouterManager shareInstance] ll_registUrl:@"xx://my_setting" routeBack:^(id _Nonnull obj, XXDataBack  _Nonnull dataBack) {
        LLHomeSettingViewController *targetVC = [[LLHomeSettingViewController alloc] init];
        [[(AppDelegate *)[UIApplication sharedApplication].delegate naVC] pushViewController:targetVC animated:YES];
    }];
    
    [[LLRouterManager shareInstance] ll_registUrl:@"xx://setting_changeInfo" routeBack:^(id _Nonnull obj, XXDataBack  _Nonnull dataBack) {
        LLSettingChangeInfoViewController *targetVC = [[LLSettingChangeInfoViewController alloc] init];
        targetVC.ChangeCallback = dataBack;
        [[(AppDelegate *)[UIApplication sharedApplication].delegate naVC] pushViewController:targetVC animated:YES];
    }];
    
    [[LLRouterManager shareInstance] ll_registUrl:@"xx://setting_changePassword" routeBack:^(id _Nonnull obj, XXDataBack  _Nonnull dataBack) {
        LLSettingSetPasswordViewController *targetVC = [[LLSettingSetPasswordViewController alloc] init];
        BOOL isLogin = NO;
        NSString *phoneNum = nil;
        if (obj && [obj isKindOfClass:[NSDictionary class]]) {
            isLogin = [obj[@"isLogin"] boolValue];
            if (isLogin) {
                //找回密码登陆
                phoneNum = obj[@"phoneNum"];
            } else {
                //只是修改密码
            }
        }
        targetVC.isLogin = isLogin;
        targetVC.phoneNum = phoneNum;
        //已经弹出一个导航栏了！
        UINavigationController *naVC = [(AppDelegate *)[UIApplication sharedApplication].delegate naVC];
        if (naVC.presentedViewController) {
            naVC = (UINavigationController *)naVC.presentedViewController;
        }
        [naVC pushViewController:targetVC animated:YES];
    }];
    
    [[LLRouterManager shareInstance] ll_registUrl:@"xx://setting_verifyNext" routeBack:^(id _Nonnull obj, XXDataBack  _Nonnull dataBack) {
        LLSettingVerifyNextViewController *targetVC = [[LLSettingVerifyNextViewController alloc] init];
        
        UINavigationController *targetNa = [[UINavigationController alloc] initWithRootViewController:targetVC];
        targetNa.navigationBar.hidden = YES;
        targetNa.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [[(AppDelegate *)[UIApplication sharedApplication].delegate naVC] presentViewController:targetNa animated:YES completion:NULL];
    }];
    
    [[LLRouterManager shareInstance] ll_registUrl:@"xx://setting_logout" routeBack:^(id _Nonnull obj, XXDataBack  _Nonnull dataBack) {
        [LLUserManager ll_loginOut];
    }];
    
}
@end
