//
//  LLCircleView.m
//  LLMovie
//
//  Created by xin xian on 2021/3/14.
//

#import "LLCircleView.h"
#import <MJRefresh/MJRefresh.h>
#import "LLCircleModel.h"
#import "LLCircleListCell.h"
#import "HZYImageScanView.h"

@interface LLCircleView() <UITableViewDelegate, UITableViewDataSource, LLCircleListCellDelegate, HZYImageScanViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <LLCircleModel *> *circleList;
@property (nonatomic, strong) UIButton *publicButton;
@property (nonatomic, copy) NSIndexPath *scanPath;
@end

@implementation LLCircleView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.circleList = [NSMutableArray array];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [UIView new];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView=tableView];
        
        tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(ll_refresh)];
        tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(ll_loadMore)];
        
        UIButton *publicButton = [UIButton buttonWithType:UIButtonTypeCustom];
        publicButton.frame = CGRectMake(XX_SCREEN_WIDTH-XX_ADJUST_SIZE(161+12), (XX_SCREEN_HEIGHT-XX_ADJUST_SIZE(161))/2, XX_ADJUST_SIZE(161), XX_ADJUST_SIZE(161));
        [publicButton setImage:[UIImage imageNamed:@"ll_circil_public_add"] forState:UIControlStateNormal];
        
        [publicButton addTarget:self action:@selector(ll_clickPublic) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.publicButton=publicButton];
        
        [self ll_loadLastCacheData];
    }
    return self;
}

- (void)ll_loadLastCacheData {
    [self.circleList removeAllObjects];
    {
        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"home_circle_data" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[LLCircleModel class] json:jsonString];
        [self.circleList addObjectsFromArray:dataArray];
    }
    
    if ([LLUserManager isLogin]) {
        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"my_circle_data" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[LLCircleModel class] json:jsonString];
        for (LLCircleModel *temp in dataArray) {
            [temp ll_setIsMyCircle];
        }
        [self.circleList addObjectsFromArray:dataArray];
    }
    [self.tableView reloadData];
}

- (void)ll_update {
    [self ll_loadLastCacheData];
}

- (void)ll_clickPublic {
    if (![LLUserManager isLogin]) {
        [LLUserManager ll_showLogin];
        return;
    }
    [[LLRouterManager shareInstance] ll_routeUrl:@"xx://circle_public" obj:nil];
}

- (void)ll_refresh {
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
    LLCircleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLCircleListCell"];
    if (!cell) {
        cell = [[LLCircleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LLCircleListCell"];
        cell.delegate = self;
    }
    [cell setData:self.circleList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    LLCircleListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self ll_gotoDetail:cell];
}

- (void)cellClickHeader:(LLCircleListCell *)cell {
    [self ll_gotoDetail:cell];
}

- (void)ll_gotoDetail:(LLCircleListCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LLCircleModel *model = self.circleList[indexPath.row];
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

- (void)cellClickComment:(LLCircleListCell *)cell {
    [self ll_gotoDetail:cell];
}

- (void)cellClickCollect:(LLCircleListCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LLCircleModel *model = self.circleList[indexPath.row];
    model.isCollect = !model.isCollect;
    [JKAlert alertText:model.isCollect?@"已点赞":@"已取消"];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)cellClickReport:(LLCircleListCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LLCircleModel *model = self.circleList[indexPath.row];
    if ([model ll_isSelf]) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [JKAlert alertText:@"已删除"];
            [self.circleList removeObject:model];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertVC animated:YES completion:NULL];
        
    } else {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[LLRouterManager shareInstance] ll_routeUrl:@"xx://report" obj:model];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"拉黑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self xx_handleDelteAlert:model];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertVC animated:YES completion:NULL];
    }
    
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
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertVC animated:YES completion:NULL];
}

@end
