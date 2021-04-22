//
//  LLMovieScoreViewController.m
//  LLMovie
//
//  Created by xin xian on 2021/3/13.
//

#import "LLMovieScoreViewController.h"
#import "LLMovieModel.h"
#import "GBStarRateView.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>

@interface LLMovieScoreViewController ()
@property (nonatomic, strong) GBStarRateView *scoreView;
@property (nonatomic, strong) UITextView *textInput;
@end

@implementation LLMovieScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"想看" showBack:YES];
    
    [self.naView setRightTitle:@"保存" color:UIColorFromString(@"FC7C4F") frame:CGRectMake(XX_SCREEN_WIDTH-XX_ADJUST_SIZE(172), self.naView.height-XX_ADJUST_SIZE(118), XX_ADJUST_SIZE(172), XX_ADJUST_SIZE(118))];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(XX_SCREEN_WIDTH/4, XX_NAVIGATION_HEIGHT+XX_ADJUST_SIZE(86), XX_SCREEN_WIDTH/2, XX_ADJUST_SIZE(58))];
    tipLabel.font = XX_SYSTEM_FONT(40);
    tipLabel.textColor = UIColorFromString(@"AAAAAA");
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"点击星星评分";
    [self.view addSubview:tipLabel];
    
    CGFloat starSize = XX_ADJUST_SIZE(86);
    CGFloat starGap = XX_ADJUST_SIZE(69);
    
    GBStarRateView *scoreView = [[GBStarRateView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(190), tipLabel.bottom+XX_ADJUST_SIZE(58), starSize*5+starGap*4, starSize) style:GBStarRateViewStyleIncompleteStar numberOfStars:5 isAnimation:YES delegate:nil];
    scoreView.starSize = CGSizeMake(starSize, starSize);
    scoreView.spacingBetweenStars = starGap;
    [self.view addSubview:self.scoreView=scoreView];
    
    UITextView *textInput = [[UITextView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(46), scoreView.bottom + XX_ADJUST_SIZE(121), self.view.width-XX_ADJUST_SIZE(46*2), XX_ADJUST_SIZE(346))];
    textInput.placeholder = @"写几句评价吧～～";
    textInput.textColor = UIColorFromString(@"222222");
    textInput.font = XX_SYSTEM_FONT(43);
    textInput.layer.backgroundColor = [UIColorFromString(@"F0F0F0") CGColor];
    textInput.layer.cornerRadius = XX_ADJUST_SIZE(23);
    textInput.layer.masksToBounds = YES;
    [self.view addSubview:self.textInput=textInput];
}

- (void)rightClick {
    [JKAlert alertWaitingText:@"请求中..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JKAlert alertWaiting:NO];
        [JKAlert alertText:@"评分成功"];
        if (self.AddScoreCallBack) {
            self.AddScoreCallBack(@{@"score":@(self.scoreView.currentStarRate*2), @"text":self.textInput.text?self.textInput.text:0});
        }
        [self.navigationController popViewControllerAnimated:YES];
    });
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
