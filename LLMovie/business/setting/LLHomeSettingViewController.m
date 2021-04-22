//
//  LLHomeSettingViewController.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/16.
//

#import "LLHomeSettingViewController.h"
#import "LLMyHomeFunCell.h"
#import "LLUserModel.h"

@interface LLHomeSettingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <NSDictionary *> *funcList;
@end

@implementation LLHomeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"设置" showBack:YES];
    
    self.funcList = [NSMutableArray array];
    
    [self.funcList addObjectsFromArray:@[
        @{
            @"title":@"修改个人资料",
            @"routing":@"xx://setting_changeInfo"
        }, @{
            @"title":@"修改登陆密码",
            @"routing":@"xx://setting_verifyNext"
        }, @{
            @"title":@"黑名单",
            @"routing":@"xx://setting_black"
        }, @{
            @"title":@"清除缓存",
            @"routing":@"xx://setting_clearChache"
        },
    ]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, XX_NAVIGATION_HEIGHT, self.view.width, XX_SCREEN_HEIGHT-XX_SAFE_BOTTOM-XX_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = UIColorFromString(@"F0F0F0");
    tableView.tableFooterView = [self ll_createFooterView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView=tableView];
    
}

- (UIView *)ll_createFooterView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, XX_ADJUST_SIZE(138+58*2))];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, XX_ADJUST_SIZE(58), view.width, XX_ADJUST_SIZE(138));
    button.titleLabel.font = XX_SYSTEM_FONT(40);
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromString(@"F55656") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ll_clickLoginOut) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor whiteColor];
    [view addSubview:button];
    
    return view;
}

- (void)ll_clickLoginOut {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确定要退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[LLRouterManager shareInstance] ll_routeUrl:@"xx://setting_logout" obj:nil];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:NULL];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return XX_ADJUST_SIZE(138);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.funcList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLMyHomeFunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLMyHomeFunCell"];
    if (!cell) {
        cell = [[LLMyHomeFunCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LLMyHomeFunCell"];
    }
    NSDictionary *funcDict = self.funcList[indexPath.row];
    cell.titleLabel.text = funcDict[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *funcDict = self.funcList[indexPath.row];
    NSString *routing = funcDict[@"routing"];
    
    if ([routing isEqualToString:@"xx://setting_clearChache"]) {
        //清除缓存
        [self ll_handleClearCache];
        return;
    }
    
    [[LLRouterManager shareInstance] ll_routeUrl:routing obj:nil];
    
}

- (void)ll_handleClearCache {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确定要清除缓存吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [JKAlert alertText:@"已清除"];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:NULL];
}

@end
