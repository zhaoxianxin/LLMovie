//
//  LLMyCircleListViewController.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/15.
//

#import "LLMyCircleListViewController.h"
#import "LLCircleModel.h"
#import <MJRefresh/MJRefresh.h>
#import "LLCircleListCell.h"
#import "HZYImageScanView.h"

@interface LLMyCircleListViewController () <UITableViewDelegate, UITableViewDataSource, LLCircleListCellDelegate, HZYImageScanViewDelegate>
@property (nonatomic, strong) NSMutableArray <LLCircleModel *> *circleList;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSIndexPath *scanPath;
@end

@implementation LLMyCircleListViewController

- (UIButton *)nothingButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.size = CGSizeMake(XX_ADJUST_SIZE(346), XX_ADJUST_SIZE(127));
    button.layer.backgroundColor = [UIColorFromString(@"252525") CGColor];
    button.layer.cornerRadius = button.height/2;
    button.layer.masksToBounds = YES;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"发布" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ll_clickPublish) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (NSString *)nothingImage {
    return @"ll_my_circle_none";
}

- (void)ll_clickPublish {
    [self rightClick];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavTitle:@"我的动态" showBack:YES];
    self.naView.showLine = YES;
    self.circleList = [NSMutableArray array];
    
    [self.naView setRightImage:[UIImage imageNamed:@"ll_nav_publish_add"]];
    
    {
        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"my_circle_data" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[LLCircleModel class] json:jsonString];
        for (LLCircleModel *temp in dataArray) {
            [temp ll_setIsMyCircle];
        }
        [self.circleList addObjectsFromArray:dataArray];
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, XX_NAVIGATION_HEIGHT, self.view.width, XX_SCREEN_HEIGHT-XX_SAFE_BOTTOM-XX_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView=tableView];
    tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(xx_refresh)];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(ll_loadMore)];
    
    [self setShowNothingView:self.circleList.count==0];
}

- (void)rightClick {
    __weak typeof(self)weakSelf = self;
    [[LLRouterManager shareInstance] ll_routeUrl:@"xx://circle_public" obj:nil dataBack:^(id  _Nonnull obj) {
        if (obj && [obj isKindOfClass:[LLCircleModel class]]) {
            [weakSelf.circleList insertObject:obj atIndex:0];
            [weakSelf.tableView reloadData];
            [weakSelf setShowNothingView:weakSelf.circleList.count==0];
        }
    }];
}

- (void)xx_refresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)ll_loadMore {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLCircleModel *model = self.circleList[indexPath.row];
    return model.xx_cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.circleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLCircleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CircleDetailCell"];
    if (!cell) {
        cell = [[LLCircleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CircleDetailCell"];
        cell.delegate = self;
    }
    [cell setData:self.circleList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    LLCircleListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self xx_gotoContentDetail:cell];
}

- (void)cellClickHeader:(LLCircleListCell *)cell {
    [self xx_gotoContentDetail:cell];
}

- (void)cellClickImage:(LLCircleListCell *)cell imageView:(UIImageView *)imageView {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LLCircleModel *model = self.circleList[indexPath.row];
    self.scanPath = indexPath;
    
    [HZYImageScanView showWithImages:model.imageList beginIndex:imageView.tag-1000 deletable:NO delegate:self];
}

- (CGRect)imageViewFrameAtIndex:(NSUInteger)index forScanView:(HZYImageScanView *)scanView {
    LLCircleListCell *cell = [self.tableView cellForRowAtIndexPath:self.scanPath];
    UIImageView *imageView = [cell ll_imageViewForIndex:index];
    return [imageView.superview convertRect:imageView.frame toView:UIApplication.sharedApplication.delegate.window];
}

- (void)cellClickCollect:(LLCircleListCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LLCircleModel *model = self.circleList[indexPath.row];
    model.isCollect = !model.isCollect;
    [JKAlert alertText:model.isCollect?@"已点赞":@"已取消"];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)cellClickComment:(LLCircleListCell *)cell {
    [self xx_gotoContentDetail:cell];
}

- (void)xx_gotoContentDetail:(LLCircleListCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LLCircleModel *model = self.circleList[indexPath.row];
    model.userId = [LLUserManager loginUserId]; // 标记为自己发的
    __weak typeof(self)weakSelf = self;
    [[LLRouterManager shareInstance] ll_routeUrl:@"xx://circle_detail" obj:model dataBack:^(id  _Nonnull obj) {
        NSInteger type = [obj[@"type"] integerValue];
        if (type == 0) {
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } else if (type == 1) {
            [weakSelf.circleList removeObject:model];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)cellClickReport:(LLCircleListCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (![LLUserManager isLogin]) {
            [LLUserManager ll_showLogin];
            return;
        }
        [JKAlert alertWaitingText:@"请求中..."];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JKAlert alertWaiting:NO];
            [JKAlert alertText:@"已删除"];
            [self.circleList removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self setShowNothingView:self.circleList.count==0];
        });
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:NULL];
}


@end
