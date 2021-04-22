//
//  LLMyMovieWillViewController.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/15.
//

#import "LLMyMovieWillViewController.h"
#import "LLMovieModel.h"
#import "LLMyMovieWillCell.h"
#import <MJRefresh/MJRefresh.h>

@interface LLMyMovieWillViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray <LLMovieModel *> *movieWillList;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation LLMyMovieWillViewController

- (NSString *)nothingImage {
    return @"ll_my_data_none";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"想看" showBack:YES];
    
    self.movieWillList = [NSMutableArray array];
    {
        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"home_banner_data" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[LLMovieModel class] json:jsonString];
        [self.movieWillList addObjectsFromArray:dataArray];
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, XX_NAVIGATION_HEIGHT, self.view.width, XX_SCREEN_HEIGHT-XX_SAFE_BOTTOM-XX_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView=tableView];
    tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(xx_refresh)];
    
    [self setShowNothingView:self.movieWillList.count==0];
}

- (void)xx_refresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return XX_ADJUST_SIZE(403+29);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movieWillList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLMyMovieWillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyRelationUserCell"];
    if (!cell) {
        cell = [[LLMyMovieWillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyRelationUserCell"];
    }
    LLMovieModel *model = self.movieWillList[indexPath.row];
    [cell.iconIV xx_imageWithUrl:model.thumbImage];
    cell.nameLabel.text = model.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    LLMovieModel *model = self.movieWillList[indexPath.row];
    model.hasFlowWill = YES; // 标记为已想看
    __weak typeof(self)weakSelf = self;
    [[LLRouterManager shareInstance] ll_routeUrl:@"xx://home_detail" obj:model dataBack:^(id  _Nonnull obj) {
        if (model.hasFlowWill) {
            //又添加到想看
            if (![weakSelf.movieWillList containsObject:obj]) {
                [weakSelf.movieWillList addObject:obj];
                [weakSelf.tableView reloadData];
            }
        } else {
            //移除想看
            if ([weakSelf.movieWillList containsObject:obj]) {
                [weakSelf.movieWillList removeObject:obj];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }];
}

@end
