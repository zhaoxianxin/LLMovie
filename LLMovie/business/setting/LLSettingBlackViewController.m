//
//  LLSettingBlackViewController.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/15.
//

#import "LLSettingBlackViewController.h"
#import "LLUserModel.h"
#import "LLSettingBlackCell.h"
#import <MJRefresh/MJRefresh.h>

@interface LLSettingBlackViewController () <UITableViewDelegate, UITableViewDataSource, LLSettingBlackCellDelegate>
@property (nonatomic, strong) NSMutableArray <LLUserModel *> *deleteList;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation LLSettingBlackViewController

- (NSString *)nothingText {
    return @"黑名单为空";
}

- (CGSize)nothingImageSize {
    return CGSizeMake(XX_ADJUST_SIZE(251), XX_ADJUST_SIZE(317));
}

- (NSString *)nothingImage {
    return @"ll_my_black_none";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"黑名单" showBack:YES];
    
    self.deleteList = [NSMutableArray array];
    
    {
        LLUserModel *model = [[LLUserModel alloc] init];
        model.userId = @"10";
        model.userName = @"凤凰集香木";
        model.userIcon = @"xx_rand_header_10@3x";
        [self.deleteList addObject:model];
    }
    {
        LLUserModel *model = [[LLUserModel alloc] init];
        model.userId = @"11";
        model.userName = @"机智的小蹦蹦";
        model.userIcon = @"xx_rand_header_11@3x";
        [self.deleteList addObject:model];
    }
    {
        LLUserModel *model = [[LLUserModel alloc] init];
        model.userId = @"12";
        model.userName = @"织梦者";
        model.userIcon = @"xx_rand_header_12@3x";
        [self.deleteList addObject:model];
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, XX_NAVIGATION_HEIGHT, self.view.width, XX_SCREEN_HEIGHT-XX_SAFE_BOTTOM-XX_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView=tableView];
    tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(xx_refresh)];
    
    [self setShowNothingView:self.deleteList.count==0];
}

- (void)xx_refresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return XX_ADJUST_SIZE(161);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deleteList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLSettingBlackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLSettingBlackCell"];
    if (!cell) {
        cell = [[LLSettingBlackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LLSettingBlackCell"];
        cell.delegate = self;
    }
    LLUserModel *model = self.deleteList[indexPath.row];
    [cell setData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)cellDidClickRemoveBlack:(LLSettingBlackCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LLUserModel *model = self.deleteList[indexPath.row];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"确定要将%@移出黑名单吗？", model.userName] preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [JKAlert alertText:@"已移出"];
        [self.deleteList removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertVC animated:YES completion:NULL];
}


@end
