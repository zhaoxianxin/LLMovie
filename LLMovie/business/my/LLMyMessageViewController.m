//
//  LLMyMessageViewController.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/15.
//

#import "LLMyMessageViewController.h"

@interface LLMyMessageViewController ()

@end

@implementation LLMyMessageViewController

- (NSString *)nothingImage {
    return @"ll_my_messages_none";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"我的消息" showBack:YES];
    [self setShowNothingView:YES];
}

@end
