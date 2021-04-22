//
//  LLMyAboutUsViewController.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/16.
//

#import "LLMyAboutUsViewController.h"
#import "LLMyHomeFunCell.h"

@interface LLMyAboutUsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation LLMyAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"关于我们" showBack:YES];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, XX_NAVIGATION_HEIGHT, self.view.width, XX_SCREEN_HEIGHT-XX_SAFE_BOTTOM-XX_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = [self ll_createHeaderView];
    tableView.tableFooterView = [UIView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView=tableView];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

- (UIView *)ll_createHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    
    CGFloat top = XX_ADJUST_SIZE(86);
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, top, self.view.width, XX_ADJUST_SIZE(81))];
        label.font = XX_SYSTEM_FONT(58);
        label.textColor = UIColorFromString(@"222222");
        label.textAlignment = NSTextAlignmentCenter;
        label.text = NSBundle.mainBundle.infoDictionary[@"CFBundleDisplayName"];
        [view addSubview:label];
        
        top += label.height;
    }
    
    top += XX_ADJUST_SIZE(23);
    
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, top, self.view.width, XX_ADJUST_SIZE(52))];
        label.font = XX_SYSTEM_FONT(37);
        label.textColor = UIColorFromString(@"222222");
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"V%@", NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"]];
        [view addSubview:label];
        
        top += label.height;
    }
    
    top += XX_ADJUST_SIZE(86);
    
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, top, self.view.width, XX_LINE_SIZE)];
        lineView.backgroundColor = UIColorFromString(@"EDEDED");
        [view addSubview:lineView];
        
        top += lineView.height;
    }
    
    view.height = top;
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return XX_ADJUST_SIZE(138);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLMyHomeFunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLMyHomeFunCell"];
    if (!cell) {
        cell = [[LLMyHomeFunCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LLMyHomeFunCell"];
        [cell ll_showLine];
    }
    cell.titleLabel.text = indexPath.row == 0 ? @"服务协议" : @"隐私政策";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *showName = indexPath.row == 0 ? @"服务协议" : @"隐私政策";
    NSString *fileName = indexPath.row == 0 ? XX_PROTOCOL_SERVICE_LINK : XX_PROTOCOL_PRIVACY_LINK;
    
    [[LLRouterManager shareInstance] ll_routeUrl:@"xx://my_protocol" obj:@{
        @"showName": showName,
        @"fileName": fileName,
    }];
}

@end
