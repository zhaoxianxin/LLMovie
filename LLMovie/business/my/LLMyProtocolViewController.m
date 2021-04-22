//
//  LLMyProtocolViewController.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/16.
//

#import "LLMyProtocolViewController.h"
#import <WebKit/WebKit.h>

@interface LLMyProtocolViewController () <WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation LLMyProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:self.showName showBack:YES];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.selectionGranularity = WKSelectionGranularityCharacter;
    config.allowsInlineMediaPlayback = YES;
    config.processPool = [[WKProcessPool alloc] init];
    if (@available(iOS 10.0, *)) {
        config.dataDetectorTypes = UIDataDetectorTypePhoneNumber | UIDataDetectorTypeLink;
    }
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, XX_NAVIGATION_HEIGHT, self.view.width, XX_SCREEN_HEIGHT-XX_SAFE_BOTTOM-XX_NAVIGATION_HEIGHT) configuration:config];
    webView.navigationDelegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView=webView];
    
    NSURL *url = nil;
    if ([self.fileName hasPrefix:@"http://"] || [self.fileName hasPrefix:@"https://"]) {
        url = [NSURL URLWithString:self.fileName];
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:self.fileName ofType:@"docx"];
        url = [NSURL fileURLWithPath:path];
    }
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
