//
//  LLHomeDetailViewController.m
//  LLMovie
//
//  Created by xin xian on 2021/3/12.
//

#import "LLHomeDetailViewController.h"
#import "LLMovieModel.h"
#import "LLMovieCommentModel.h"
#import "LLMovieLabel.h"
#import "GBStarRateView.h"
#import "LLDetailCommentCell.h"
#import "LLDetailContentCell.h"
#import "LLDetailCommentNonCell.h"
#import "LLDetailRoleListCell.h"
#import <MJRefresh/MJRefresh.h>
#import "LLDetailInputView.h"
#import "LLStartView.h"
#import "HZYImageScanView.h"

@interface LLHomeDetailViewController () <UITableViewDelegate, UITableViewDataSource, HZYImageScanViewDelegate, LLDetailRoleListCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) LLDetailInputView *bottomView;
@property (nonatomic, strong) UIView *stateActionView;
@property (nonatomic, assign) BOOL isClickRole;
@property (nonatomic, assign) NSInteger clickRoleIndex;
@property (nonatomic, strong) UIImageView *iconIV;
@end

@implementation LLHomeDetailViewController

- (NSArray <LLMovieCommentModel *> *)commentList {
    return self.model.commentList;
}

- (NSArray <LLMovieRoleModel *> *)roleList {
    return self.model.roleList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"" showBack:YES];
    
    self.naView.backgroundColor = [UIColor clearColor];
    
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XX_SCREEN_WIDTH-XX_ADJUST_SIZE(43*2), XX_ADJUST_SIZE(58))];
        label.numberOfLines = 0;
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = XX_ADJUST_SIZE(10);
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:self.model.desc attributes:@{
            NSFontAttributeName: XX_SYSTEM_FONT(40),
            NSParagraphStyleAttributeName: style,
        }];
        label.attributedText = attr;
        [label sizeToFit];
        if (label.height < XX_ADJUST_SIZE(58)) {
            label.height = XX_ADJUST_SIZE(58);
        }
        self.contentHeight = label.height;
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, XX_SCREEN_HEIGHT-XX_ADJUST_SIZE(161)-XX_SAFE_BOTTOM) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = [self xx_createHeaderView];
    tableView.tableFooterView = [self xx_createFooterView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = UIColorFromString(@"F0F0F0");
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view insertSubview:self.tableView=tableView belowSubview:self.naView];
    
    tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(ll_refresh)];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(ll_loadMore)];
    
    LLDetailInputView *bottomView = [[LLDetailInputView alloc] initWithFrame:CGRectMake(0, XX_SCREEN_HEIGHT-XX_ADJUST_SIZE(161)-XX_SAFE_BOTTOM, self.view.width, XX_ADJUST_SIZE(161)+XX_SAFE_BOTTOM)];
    [bottomView.sendButton addTarget:self action:@selector(xx_clickSend) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomView=bottomView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xx_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xx_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ll_didLogin) name:XXUserDidLoginNotifation object:nil];
}

- (void)ll_didLogin {
    self.tableView.tableHeaderView = [self xx_createHeaderView];
}

- (void)xx_clickSend {
    if (![LLUserManager isLogin]) {
        [LLUserManager ll_showLogin];
        return;
    }
    if (self.bottomView.bottomInput.text.length == 0) {
        [JKAlert alertText:@"请输入内容"];
        return;
    }
    [self.view endEditing:NO];
    
    [JKAlert alertWaitingText:@"请求中..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JKAlert alertWaiting:NO];
        [JKAlert alertText:@"已发送"];
        
        LLMovieCommentModel *model = [[LLMovieCommentModel alloc] init];
        model.modelId = [self.commentList lastObject].modelId+1;
        model.userName = [LLUserManager loginUserName];
        model.userIcon = [LLUserManager loginImage];
        model.content = self.bottomView.bottomInput.text;
        {
            NSDate *currentDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
            model.time = currentDateString;
        }
        
        [self.model.commentList addObject:model];
        [self.tableView reloadData];
        
        self.bottomView.bottomInput.text = nil;
    });
    
}

- (void)xx_keyboardWillShow:(NSNotification *)nf {
    CGRect keyboardRect = [[nf.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardRect.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.bottom = XX_SCREEN_HEIGHT - height;
    }];
}

- (void)xx_keyboardWillHide:(NSNotification *)nf {
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.top = XX_SCREEN_HEIGHT-XX_ADJUST_SIZE(161)-XX_SAFE_BOTTOM;
    }];
}

- (void)ll_loadMore {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    });
}

- (void)ll_refresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

- (UIView *)xx_createHeaderView {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    header.layer.borderWidth = XX_ADJUST_SIZE(3);
    header.layer.borderColor = [UIColorFromString(@"979797") CGColor];
    
    CGFloat top = XX_NAVIGATION_HEIGHT+XX_ADJUST_SIZE(43);
    
    UIImageView *iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(43), top, XX_ADJUST_SIZE(288), XX_ADJUST_SIZE(363))];
    iconIV.layer.masksToBounds = YES;
    iconIV.layer.cornerRadius = XX_ADJUST_SIZE(23);
    [iconIV xx_imageWithUrl:self.model.thumbImage];
    iconIV.userInteractionEnabled = YES;
    {
        UITapGestureRecognizer *tapTemp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ll_tapThumImage)];
        [iconIV addGestureRecognizer:tapTemp];
    }
    [header addSubview:self.iconIV=iconIV];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconIV.right+XX_ADJUST_SIZE(43), top, header.width-XX_ADJUST_SIZE(43*2)-iconIV.right, XX_ADJUST_SIZE(86))];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = XX_SYSTEM_FONT(63);
    nameLabel.text = self.model.title;
    [header addSubview:nameLabel];
    
    UILabel *nameEngLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+XX_ADJUST_SIZE(12), nameLabel.width, XX_ADJUST_SIZE(60))];
    nameEngLabel.textColor = [UIColor whiteColor];
    nameEngLabel.font = XX_SYSTEM_FONT(43);
    nameEngLabel.text = self.model.titleEng;
    [header addSubview:nameEngLabel];
    
    CGFloat labelOriginY = nameEngLabel.bottom+XX_ADJUST_SIZE(35);
    CGFloat labelOriginX = nameLabel.left;
    for (int i = 0; i < 3; i++) {
        if (i >= self.model.labelList.count) {
            continue;
        }
        LLMovieLabel *label = [LLMovieLabel ll_movieLabelWithOrigin:CGPointMake(labelOriginX, labelOriginY)];
        label.text = self.model.labelList[i];
        label.textColor = [UIColor whiteColor];
        label.layer.backgroundColor = [UIColorFromString(@"FFFFFF26") CGColor];
        
        [header addSubview:label];
        labelOriginX += (label.width+XX_ADJUST_SIZE(35));
    }
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameEngLabel.bottom+XX_ADJUST_SIZE(132), nameLabel.width, XX_ADJUST_SIZE(46))];
    timeLabel.textColor = UIColorFromString(@"FFFFFFCC");
    timeLabel.font = XX_SYSTEM_FONT(32);
    timeLabel.text = [NSString stringWithFormat:@"%@（%@）上映 / %d分钟", self.model.showTime, self.model.showPlace, (int)self.model.totalMinute];
    [header addSubview:timeLabel];
    
    top += iconIV.height;
    
    top += XX_ADJUST_SIZE(58);
    //黑色区域
    UIView *blackArea = [[UIView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(43), top, header.width-XX_ADJUST_SIZE(43*2), XX_ADJUST_SIZE(161))];
    blackArea.backgroundColor = UIColorFromString(@"0000004D");
    blackArea.layer.cornerRadius = XX_ADJUST_SIZE(23);
    blackArea.layer.masksToBounds = YES;
    [header addSubview:blackArea];
    {
        UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(58), XX_ADJUST_SIZE(17), XX_ADJUST_SIZE(150), XX_ADJUST_SIZE(86))];
        scoreLabel.textColor = [UIColor whiteColor];
        scoreLabel.font = XX_SYSTEM_FONT(63);
        scoreLabel.text = [NSString stringWithFormat:@"%.1f", self.model.score];
        [blackArea addSubview:scoreLabel];
        
        LLStartView *scoreView = [LLStartView ll_startWithScore:self.model.score];
        scoreView.origin = CGPointMake(XX_ADJUST_SIZE(58), scoreLabel.bottom);
        [blackArea addSubview:scoreView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(300), (blackArea.height-XX_ADJUST_SIZE(86))/2, XX_ADJUST_SIZE(3), XX_ADJUST_SIZE(86))];
        lineView.backgroundColor = UIColorFromString(@"FFFFFF4D");
        [blackArea addSubview:lineView];
        
        UILabel *didLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineView.right + XX_ADJUST_SIZE(55), XX_ADJUST_SIZE(52), XX_ADJUST_SIZE(250), XX_ADJUST_SIZE(58))];
        didLabel.textColor = [UIColor whiteColor];
        didLabel.font = XX_SYSTEM_FONT(40);
        didLabel.text = [NSString stringWithFormat:@"%d人看过", (int)self.model.flowDid];
        [blackArea addSubview:didLabel];
        
        UILabel *willLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineView.right + XX_ADJUST_SIZE(389), XX_ADJUST_SIZE(52), XX_ADJUST_SIZE(250), XX_ADJUST_SIZE(58))];
        willLabel.textColor = [UIColor whiteColor];
        willLabel.font = XX_SYSTEM_FONT(40);
        willLabel.text = [NSString stringWithFormat:@"%d人想看", (int)self.model.flowWill];
        [blackArea addSubview:willLabel];
        
    }
    
    top += blackArea.height;
    top += XX_ADJUST_SIZE(58);
    
    //状态
    UIView *stateActionView = [[UIView alloc] initWithFrame:CGRectMake(0, top, header.width, XX_ADJUST_SIZE(98))];
    [header addSubview:self.stateActionView=stateActionView];
    if (self.model.hasScored && [LLUserManager isLogin]) {
        //已看过（评过分）
        [self ll_realodActioViewAfterScored];
    } else {
        //未评分，是否已想看
        UIButton *willButton = [UIButton buttonWithType:UIButtonTypeCustom];
        willButton.frame = CGRectMake(XX_ADJUST_SIZE(43), 0, XX_ADJUST_SIZE(374), XX_ADJUST_SIZE(98));
        willButton.layer.cornerRadius = willButton.height/2;
        willButton.layer.masksToBounds = YES;
        willButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
        [willButton addTarget:self action:@selector(ll_willButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [willButton setTitleColor:UIColorFromString(@"222222") forState:UIControlStateNormal];
        willButton.titleLabel.font = XX_SYSTEM_FONT(40);
        if (self.model.hasFlowWill && [LLUserManager isLogin]) {
            [willButton setTitle:@"已想看" forState:UIControlStateNormal];
        } else {
            [willButton setImage:[UIImage imageNamed:@"ll_home_detail_action_1"] forState:UIControlStateNormal];
        }
        [stateActionView addSubview:willButton];
        
        UIButton *didButton = [UIButton buttonWithType:UIButtonTypeCustom];
        didButton.frame = CGRectMake(willButton.right + XX_ADJUST_SIZE(43), 0, XX_ADJUST_SIZE(576), XX_ADJUST_SIZE(98));
        didButton.layer.cornerRadius = didButton.height/2;
        didButton.layer.masksToBounds = YES;
        didButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
        [didButton addTarget:self action:@selector(ll_didButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [didButton setImage:[UIImage imageNamed:@"ll_home_detail_action_2"] forState:UIControlStateNormal];
        [stateActionView addSubview:didButton];
        
    }
    
    top += XX_ADJUST_SIZE(98+78);
    header.height = top;
    
    int randIndex = (self.model.modelId-1) % 3;
    UIColor *fromColor = nil;
    UIColor *toColor = nil;
    if (randIndex == 0) {
        fromColor = UIColorFromString(@"897E78");
        toColor = UIColorFromString(@"514843");
    } else if (randIndex == 1) {
        fromColor = UIColorFromString(@"45516D");
        toColor = UIColorFromString(@"262F44");
    } else {
        fromColor = UIColorFromString(@"5B6D88");
        toColor = UIColorFromString(@"8F9FB7");
    }
    
    UIView *backView = [[UIView alloc] initWithFrame:header.bounds];
    [CALayer xx_addGradientLayerColor:fromColor toColor:toColor fromPoint:CGPointMake(0, 0) toPoint:CGPointMake(backView.width, backView.height) toView:backView];
    [header insertSubview:backView atIndex:0];
    
    return header;
}

- (void)ll_tapThumImage {
    self.isClickRole = NO;
    [HZYImageScanView showWithImages:@[self.model.thumbImage] beginIndex:0 deletable:NO delegate:self];
}

- (CGRect)imageViewFrameAtIndex:(NSUInteger)index forScanView:(HZYImageScanView *)scanView {
    if (self.isClickRole) {
        LLDetailRoleListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        UIImageView *imageView = [cell ll_roleImageViewForIndex:self.clickRoleIndex];
        return [imageView.superview convertRect:imageView.frame toView:UIApplication.sharedApplication.delegate.window];
    } else {
        return [self.iconIV.superview convertRect:self.iconIV.frame toView:UIApplication.sharedApplication.delegate.window];
    }
}

- (void)ll_realodActioViewAfterScored {
    NSArray *views = [self.stateActionView subviews];
    for (UIView *view in views) {
        [view removeFromSuperview];
    }
    
    UIView *didView = [[UIView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(43), 0, self.stateActionView.width-XX_ADJUST_SIZE(43*2), XX_ADJUST_SIZE(98))];
    didView.layer.cornerRadius = didView.height/2;
    didView.layer.masksToBounds = YES;
    didView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.stateActionView addSubview:didView];
    
    LLStartView *scoreView = [LLStartView ll_startWithScore:self.model.score size:XX_ADJUST_SIZE(48)];
    scoreView.origin = CGPointMake(XX_ADJUST_SIZE(297), XX_ADJUST_SIZE(26));
    scoreView.currentStarRate = self.model.myScore;
    [didView addSubview:scoreView];
    
    UILabel *didLabel = [[UILabel alloc] initWithFrame:CGRectMake(scoreView.right + XX_ADJUST_SIZE(20), XX_ADJUST_SIZE(20), XX_ADJUST_SIZE(200), XX_ADJUST_SIZE(58))];
    didLabel.textColor = UIColorFromString(@"222222");
    didLabel.font = XX_SYSTEM_FONT(40);
    didLabel.text = @"已看过";
    [didView addSubview:didLabel];
    
}

- (void)ll_willButtonAction:(UIButton *)sender {
    if (![LLUserManager isLogin]) {
        [LLUserManager ll_showLogin];
        return;
    }
    if (!self.model.hasFlowWill) {
        [JKAlert alertWaitingText:@"请求中..."];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JKAlert alertWaiting:NO];
            [JKAlert alertText:@"已将电影放到想看列表"];
            self.model.hasFlowWill = YES;
            [sender setTitle:@"已想看" forState:UIControlStateNormal];
            [sender setImage:nil forState:UIControlStateNormal];
            if (self.WillStateChanged) {
                self.WillStateChanged(self.model);
            }
        });
        
        return;
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确定去掉已想看的标记？" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [JKAlert alertWaitingText:@"请求中..."];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JKAlert alertWaiting:NO];
            self.model.hasFlowWill = NO;
            [JKAlert alertText:@"已去掉"];
            [sender setTitle:nil forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"ll_home_detail_action_1"] forState:UIControlStateNormal];
            if (self.WillStateChanged) {
                self.WillStateChanged(self.model);
            }
        });
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertVC animated:YES completion:NULL];
}

- (void)ll_didButtonAction:(UIButton *)sender {
    if (![LLUserManager isLogin]) {
        [LLUserManager ll_showLogin];
        return;
    }
    __weak typeof(self)weakSelf = self;
    [[LLRouterManager shareInstance] ll_routeUrl:@"xx://detail_add_score" obj:self.model dataBack:^(id  _Nonnull obj) {
        CGFloat myScore = [obj[@"score"] floatValue];
        weakSelf.model.hasScored = YES;
        weakSelf.model.myScore = myScore;
        [weakSelf ll_realodActioViewAfterScored];
    }];
}

- (UIView *)xx_createFooterView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    return footer;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    } else {
        return self.commentList.count == 0 ? 1 : self.commentList.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return XX_ADJUST_SIZE(63+58);
    } else if (section==1) {
        return XX_ADJUST_SIZE(63+43+29);
    }
    return XX_ADJUST_SIZE(63+43+29+15);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    view.backgroundColor = [UIColor whiteColor];
    
    if (section==0) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(43), XX_ADJUST_SIZE(58), view.width/2, XX_ADJUST_SIZE(63))];
        title.text = @"剧情简介";
        title.font = XX_SYSTEM_FONT(46);
        title.textColor = UIColorFromString(@"222222");
        
        [view addSubview:title];
        
        view.height = XX_ADJUST_SIZE(63+58);
        return view;
    } else if (section==1) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, XX_ADJUST_SIZE(29))];
        lineView.backgroundColor = UIColorFromString(@"F0F0F0");
        [view addSubview:lineView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(43), lineView.bottom + XX_ADJUST_SIZE(43), view.width/2, XX_ADJUST_SIZE(63))];
        title.text = @"演职员";
        title.font = XX_SYSTEM_FONT(46);
        title.textColor = UIColorFromString(@"222222");
        [view addSubview:title];
        
        view.height = XX_ADJUST_SIZE(63+43+29);
        return view;
    } else {
    
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, XX_ADJUST_SIZE(29))];
        lineView.backgroundColor = UIColorFromString(@"F0F0F0");
        [view addSubview:lineView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(43), lineView.bottom + XX_ADJUST_SIZE(43), view.width/2, XX_ADJUST_SIZE(63))];
        title.text = @"评论";
        title.font = XX_SYSTEM_FONT(46);
        title.textColor = UIColorFromString(@"222222");
        [view addSubview:title];
        
        view.height = XX_ADJUST_SIZE(63+43+29+15);
        return view;

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return XX_ADJUST_SIZE(43*2) + self.contentHeight;
    } else if (indexPath.section == 1) {
        return XX_ADJUST_SIZE(498);
    } else {
        if (self.commentList.count == 0) {
            return XX_ADJUST_SIZE(86+184+23+49+86);
        } else {
            LLMovieCommentModel *model = self.commentList[indexPath.row];
            return XX_ADJUST_SIZE(230-58) + model.ll_contentHeight;
        }
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LLDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLDetailContentCell"];
        if (!cell) {
            cell = [[LLDetailContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LLDetailContentCell"];
        }
        [cell setData:self.model.desc height:self.contentHeight];
        return cell;
    } else if (indexPath.section == 1) {
        LLDetailRoleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLDetailRoleListCell"];
        if (!cell) {
            cell = [[LLDetailRoleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LLDetailRoleListCell"];
            cell.delegate = self;
        }
        [cell setData:self.roleList];
        return cell;
    } else {
        if (self.commentList.count == 0) {
            LLDetailCommentNonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLDetailCommentNonCell"];
            if (!cell) {
                cell = [[LLDetailCommentNonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LLDetailCommentNonCell"];
            }
            return cell;
        } else {
            
            LLDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLDetailCommentCell"];
            if (!cell) {
                cell = [[LLDetailCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LLDetailCommentCell"];
            }
            [cell setData:self.commentList[indexPath.row]];
            
            return cell;
            
        }
    }
    
    return [UITableViewCell new];
}

- (void)cell:(LLDetailRoleListCell *)cell didClickRoleAtIndex:(NSInteger)index {
    self.isClickRole = YES;
    self.clickRoleIndex = index;
    [HZYImageScanView showWithImages:@[self.model.roleList[index].userIcon] beginIndex:0 deletable:NO delegate:self];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:NO];
    self.bottomView.bottomInput.text = nil;
}

@end
