//
//  LLUserCircleListViewController.m
//  LLMovie
//
//  Created by xin xian on 2021/3/14.
//

#import "LLUserCircleListViewController.h"
#import "LLUserModel.h"
#import "LLCircleModel.h"
#import "LLCircleListCell.h"
#import <MJRefresh/MJRefresh.h>

@interface LLUserCircleListViewController () <LLCircleListCellDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LLUserModel *userModel;
@property (nonatomic, strong) NSMutableArray <LLCircleModel *> *circleList;
@property (nonatomic, strong) UIButton *subsribeButton;
@end

@implementation LLUserCircleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavTitle:@"" showBack:YES];
    [self.naView setRightImage:[UIImage imageNamed:@"home_nav_more"]];
    self.naView.isHighlighted = YES;
    self.naView.backgroundColor = [UIColor clearColor];
    
    self.circleList = [NSMutableArray array];
    
    LLUserModel *userModel = [[LLUserModel alloc] init];
    userModel.userId = @"1654566";
    userModel.userName = self.userName;
    userModel.userIcon = self.userIcon;
    userModel.userBack = @"xx_home_banner_1@3x";
    self.userModel = userModel;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, XX_SCREEN_HEIGHT-XX_SAFE_BOTTOM) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view insertSubview:self.tableView=tableView belowSubview:self.naView];
    tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(xx_refresh)];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.tableHeaderView = [self xx_createHeaderView];
    tableView.tableFooterView = [UIView new];
    
}

- (UIView *)xx_createHeaderView {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, XX_ADJUST_SIZE(651+150))];
    CGFloat top = 0;
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, header.width, XX_ADJUST_SIZE(651))];
        imageView.userInteractionEnabled = YES;
        [imageView xx_imageWithUrl:self.userModel.userBack];
        [header addSubview:imageView];
        {
            UIView *backView = [[UIView alloc] initWithFrame:imageView.bounds];
            backView.backgroundColor = [UIColor blackColor];
            backView.alpha = 0.4;
            [imageView addSubview:backView];
            
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xx_tapUserBack)];
//            [backView addGestureRecognizer:tap];
        }
        
        
        UIImageView *headIV = [[UIImageView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(23), XX_ADJUST_SIZE(156+58), XX_ADJUST_SIZE(213), XX_ADJUST_SIZE(213))];
        headIV.layer.cornerRadius = headIV.height / 2;
        headIV.userInteractionEnabled = YES;
        headIV.layer.masksToBounds = YES;
        [headIV xx_imageWithUrl:self.userModel.userIcon];
        [header addSubview:headIV];
        {
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xx_tapUserHeader)];
//            [headIV addGestureRecognizer:tap];
        }
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headIV.right + XX_ADJUST_SIZE(29), headIV.top + XX_ADJUST_SIZE(43), imageView.width-headIV.right + XX_ADJUST_SIZE(29*2), XX_ADJUST_SIZE(58))];
        nameLabel.font = XX_SYSTEM_FONT(40);
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.text = self.userModel.userName;
        [header addSubview:nameLabel];
        
        UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom + XX_ADJUST_SIZE(14), nameLabel.width, XX_ADJUST_SIZE(58))];
        idLabel.font = XX_SYSTEM_FONT(40);
        idLabel.textColor = [UIColor whiteColor];
        idLabel.text = [NSString stringWithFormat:@"ID:%@",  self.userModel.userId];
        [header addSubview:idLabel];
        
        
        top = headIV.bottom;
    }
    
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(23), XX_ADJUST_SIZE(651+43), XX_ADJUST_SIZE(200), XX_ADJUST_SIZE(63))];
        label.font = XX_SYSTEM_FONT(46);
        label.textColor = UIColorFromString(@"333333");
        label.text = @"TA动态";
        [header addSubview:label];
        
    }
    
    UILabel *subsribeLabel = [[UILabel alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(29), top + XX_ADJUST_SIZE(58), 0, 0)];
    subsribeLabel.textColor = [UIColor whiteColor];
    subsribeLabel.numberOfLines = 2;
    [subsribeLabel sizeToFit];
    [header addSubview:subsribeLabel];
    
    UILabel *followLabel = [[UILabel alloc] initWithFrame:CGRectMake(subsribeLabel.right + XX_ADJUST_SIZE(58), top + XX_ADJUST_SIZE(58), 0, 0)];
    followLabel.numberOfLines = 2;
    followLabel.textColor = [UIColor whiteColor];
    [followLabel sizeToFit];
    [header addSubview:followLabel];
    
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(header.width-XX_ADJUST_SIZE(35+242), top+XX_ADJUST_SIZE(72), XX_ADJUST_SIZE(242), XX_ADJUST_SIZE(75));
        button.titleLabel.font = XX_SYSTEM_FONT(35);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(xx_clickSubscribe) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = button.height/2;
        button.layer.masksToBounds = YES;
        button.layer.backgroundColor = [UIColorFromString(@"2BAB7A") CGColor];
        [header addSubview:self.subsribeButton=button];
    }
    
    return header;
}

- (NSAttributedString *)xx_attrWithSubsribe:(BOOL)isSubscribe count:(NSInteger)count {
    NSString *string = nil;
    CGFloat formatCount = 0;
    if (count >= 10000) {
        formatCount = count / 10000.0f;
        if (isSubscribe) {
            string = [NSString stringWithFormat:@"%.1f万\n关注", formatCount];
        } else {
            string = [NSString stringWithFormat:@"%.1f万\n粉丝", formatCount];
        }
    } else {
        if (isSubscribe) {
            string = [NSString stringWithFormat:@"%d\n关注", count];
        } else {
            string = [NSString stringWithFormat:@"%d\n粉丝", count];
        }
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = XX_ADJUST_SIZE(10);
    style.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:string attributes:@{
        NSFontAttributeName: XX_SYSTEM_FONT(40),
        NSParagraphStyleAttributeName: style,
    }];
    return attr;
}

- (void)xx_tapUserBack {
    
}

- (void)xx_tapUserHeader {
    
}

- (void)xx_clickSubscribe {
    if (![LLUserManager isLogin]) {
        [LLUserManager ll_showLogin];
        return;
    }
}

- (void)xx_refresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)rightClick {
    [[LLRouterManager shareInstance] ll_routeUrl:@"xx://report" obj:self.userModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLCircleModel *model = self.circleList[indexPath.row];
    return XX_ADJUST_SIZE(783) + model.xx_contentHeight-XX_ADJUST_SIZE(58);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.circleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLCircleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CircleDetailCell"];
    if (!cell) {
        cell = [[LLCircleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CircleDetailCell"];
        cell.delegate = self;
        [cell ll_setInDetail];
    }
    [cell setData:self.circleList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    LLCircleListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self xx_gotoContentDetail:cell];
}

- (void)xx_gotoContentDetail:(LLCircleListCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LLCircleModel *model = self.circleList[indexPath.row];
    [[LLRouterManager shareInstance] ll_routeUrl:@"xx://circle_content_detail" obj:model];
}

- (void)cellClickImage:(LLCircleListCell *)cell imageView:(UIImageView *)imageView {
    [self xx_gotoContentDetail:cell];
}

- (void)cellClickCollect:(LLCircleListCell *)cell {
    [JKAlert alertText:@"已点赞"];
}

- (void)cellClickComment:(LLCircleListCell *)cell {
    [self xx_gotoContentDetail:cell];
}

- (void)cellClickReport:(LLCircleListCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LLCircleModel *model = self.circleList[indexPath.row];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[LLRouterManager shareInstance] ll_routeUrl:@"xx://report" obj:model];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"拉黑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self xx_handleDelteAlert:model];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:NULL];
}

- (void)xx_handleDelteAlert:(LLCircleModel *)model {
    if (![LLUserManager isLogin]) {
        [LLUserManager ll_showLogin];
        return;
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"操作" message:[NSString stringWithFormat:@"是否要将%@拉黑", model.userName] preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [JKAlert alertText:@"已拉黑"];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:NULL];
}

@end
