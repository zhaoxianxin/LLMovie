//
//  LLHomeView.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/12.
//

#import "LLHomeView.h"
#import <MJRefresh/MJRefresh.h>
#import "LLHomeRecommendCell.h"
#import "UIScrollView+VisibleCenter.h"

@interface LLHomeViewSegmentView : UIView
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray <NSDictionary *> *dataList;
@property (nonatomic, assign) NSInteger currIndex;
@property (nonatomic, copy) void(^LLSegmentChangeIndex)(NSInteger index);
@end

@implementation LLHomeViewSegmentView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView=scrollView];
    }
    return self;
}

- (void)ll_setDataList:(NSArray <NSDictionary *> *)dataList {
    self.dataList = dataList;
    CGFloat gap = XX_ADJUST_SIZE(29);
    CGSize itemSize = CGSizeMake(XX_ADJUST_SIZE(138), XX_ADJUST_SIZE(69));
    CGFloat top = (self.height-itemSize.height)/2;
    CGRect lineRect = CGRectMake(XX_ADJUST_SIZE(14), (itemSize.height-XX_ADJUST_SIZE(29))/2, XX_ADJUST_SIZE(6), XX_ADJUST_SIZE(29));
    //收尾没有间隔
    for (int i = 0; i< dataList.count; i++) {
        NSDictionary *dict = dataList[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((itemSize.width+gap)*i, top, itemSize.width, itemSize.height);
        button.tag = 1000+i;
        [button setTitleColor:UIColorFromString(@"222222") forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromString(@"FFFFFF") forState:UIControlStateSelected];
        button.titleLabel.font = XX_SYSTEM_FONT(35);
        button.layer.cornerRadius = XX_ADJUST_SIZE(6);
        button.layer.masksToBounds = YES;
        [button setTitle:dict[@"title"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(ll_clickSegment:) forControlEvents:UIControlEventTouchUpInside];
        
        {
            UIView *lineView = [[UIView alloc] initWithFrame:lineRect];
            lineView.backgroundColor = UIColorFromString(@"FC7C4F");
            lineView.tag = 11111;
            [button addSubview:lineView];
        }
        [self ll_configButton:button isSelect:i == 0];
        
        [self.scrollView addSubview:button];
        
    }
    
    self.scrollView.contentSize = CGSizeMake((itemSize.width+gap)*dataList.count-gap, self.height);
    
}

- (void)ll_clickSegment:(UIButton *)sender {
    NSInteger index = sender.tag - 1000;
    if(index == self.currIndex) {
        return;
    }
    [self ll_setTargetIndex:index animation:YES];
    //外部回调
    if(self.LLSegmentChangeIndex) {
        self.LLSegmentChangeIndex(self.currIndex);
    }
}

- (void)ll_configButton:(UIButton *)button isSelect:(BOOL)selelct {
    if (selelct) {
        button.layer.backgroundColor = [UIColorFromString(@"222222") CGColor];
    } else {
        button.layer.backgroundColor = [UIColorFromString(@"F0F0F0") CGColor];
    }
    button.selected = selelct;
    UIView *lineView = [button viewWithTag:11111];
    lineView.hidden = !selelct;
}

- (void)ll_setTargetIndex:(NSInteger)index animation:(BOOL)animation {
    if (self.currIndex == index) {
        return;
    }
    //之前的去掉选中
    UIButton *preItem = [self.scrollView viewWithTag:1000+self.currIndex];
    [self ll_configButton:preItem isSelect:NO];
    //选中现在的
    UIButton *currItem = [self.scrollView viewWithTag:1000+index];
    [self ll_configButton:currItem isSelect:YES];
    
    self.currIndex = index;
    //滚动到中间
    CGRect frame = CGRectMake(currItem.left, 0, currItem.width, self.height);
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.scrollView xx_scrollRectToVisibleCenteredOn:frame animated:YES];
    } completion:^(BOOL finished) {
        
    }];
    
}

@end

@interface LLHomeViewBannerView : UIView
@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) LLMovieModel *model;
@end

@implementation LLHomeViewBannerView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ll_tapHeader)];
            [self addGestureRecognizer:tap];
        }
        
        UIView *backgroudIV = [[UIView alloc] initWithFrame:self.bounds];
        backgroudIV.backgroundColor = UIColorFromString(@"F0F0F0");
        backgroudIV.layer.cornerRadius = XX_ADJUST_SIZE(23);
        backgroudIV.layer.masksToBounds = YES;
        [self addSubview:backgroudIV];
        
        UIImageView *headerIV = [[UIImageView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(29), XX_ADJUST_SIZE(29), XX_ADJUST_SIZE(282), XX_ADJUST_SIZE(346))];
        headerIV.backgroundColor = UIColorFromString(@"A2A2A2");
        headerIV.layer.cornerRadius = XX_ADJUST_SIZE(23);
        headerIV.layer.masksToBounds = YES;
        [self addSubview:self.headerIV=headerIV];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerIV.right + XX_ADJUST_SIZE(29), headerIV.top + XX_ADJUST_SIZE(29), self.width-XX_ADJUST_SIZE(29*2)-headerIV.right, XX_ADJUST_SIZE(161))];
        nameLabel.font = XX_SYSTEM_FONT(58);
        nameLabel.textColor = UIColorFromString(@"222222");
        nameLabel.numberOfLines = 2;
        [self addSubview:self.nameLabel=nameLabel];
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, headerIV.bottom - XX_ADJUST_SIZE(14+49), nameLabel.width, XX_ADJUST_SIZE(49))];
        countLabel.font = XX_SYSTEM_FONT(35);
        countLabel.textColor = UIColorFromString(@"AAAAAA");
        countLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.countLabel=countLabel];
        
    }
    return self;
}

- (void)ll_setData:(LLMovieModel *)data {
    self.model = data;
    [self.headerIV xx_imageWithUrl:data.thumbImage];
    self.nameLabel.text = data.title;
    self.countLabel.text = [NSString stringWithFormat:@"%d人想看", (int)data.flowWill];
}

- (void)ll_tapHeader {
    [[LLRouterManager shareInstance] ll_routeUrl:@"xx://home_detail" obj:self.model];
}

@end

#import "LLHomeRecommendNoneCell.h"

@interface LLHomeView() <UITableViewDelegate, UITableViewDataSource, LLHomeRecommendCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <LLMovieModel *> *bannerList;
@property (nonatomic, strong) NSMutableArray <LLMovieModel *> *recommendList;
@property (nonatomic, strong) NSMutableArray <LLMovieModel *> *currentList;
@property (nonatomic, strong) NSMutableArray <NSDictionary *> *segmentList;
@property (nonatomic, strong) LLHomeViewSegmentView *segmentView;
@end

@implementation LLHomeView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bannerList = [NSMutableArray array];
        self.recommendList = [NSMutableArray array];
        self.currentList = [NSMutableArray array];
        self.segmentList = [NSMutableArray array];
        {
            [self.segmentList addObjectsFromArray:@[
                @{@"title":@"全部"},
                @{@"title":@"喜剧"},
                @{@"title":@"爱情"},
                @{@"title":@"动作"},
                @{@"title":@"科幻"},
                @{@"title":@"动画"},
                @{@"title":@"悬疑"},
            ]];
        }
        
        {
            NSString *jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"home_banner_data" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
            NSArray *dataArray = [NSArray yy_modelArrayWithClass:[LLMovieModel class] json:jsonString];
            [self.bannerList addObjectsFromArray:dataArray];
        }
        
        {
            NSString *jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"home_recommend_data" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
            NSArray *dataArray = [NSArray yy_modelArrayWithClass:[LLMovieModel class] json:jsonString];
            [self.recommendList addObjectsFromArray:dataArray];
            [self.currentList addObjectsFromArray:dataArray];
        }
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableHeaderView = [self creatHeaderView];
        tableView.tableFooterView = [UIView new];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView=tableView];
        
        tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(ll_refresh)];
//        tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(xx_loadMore)];
        
    }
    return self;
}

- (void)ll_update {
    [self.tableView reloadData];
}

- (void)ll_refresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

//- (void)xx_loadMore {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//    });
//}

- (UIView *)creatHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, XX_ADJUST_SIZE(14+403))];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, XX_ADJUST_SIZE(14), view.width, view.height-XX_ADJUST_SIZE(14))];
    
    CGFloat itemWidth = XX_ADJUST_SIZE(783);
    CGFloat gap = XX_ADJUST_SIZE(29);
    for (int i = 0; i < self.bannerList.count; i++) {
        LLMovieModel *model = self.bannerList[i];
        LLHomeViewBannerView *itemView = [[LLHomeViewBannerView alloc] initWithFrame:CGRectMake(gap + (itemWidth+gap) * i, 0, itemWidth, scrollView.height)];
        [itemView ll_setData:model];
        [scrollView addSubview:itemView];
    }
    
    scrollView.contentSize = CGSizeMake(gap + (itemWidth+gap) * self.bannerList.count, scrollView.height);
    [view addSubview:scrollView];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return XX_ADJUST_SIZE(173);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentList.count > 0) {
        LLMovieModel *model = self.currentList[indexPath.row];
        return XX_ADJUST_SIZE(513+461+35-115) + model.ll_contentHeight;
    } else {
        //计算空白位置高度
        CGFloat blankHeight = XX_ADJUST_SIZE(259*2+472); // 最小高度
        //如果屏幕还有额外高度，则全部使用
        CGFloat offset = XX_SCREEN_HEIGHT - XX_ADJUST_SIZE(446+115) - XX_NAVIGATION_HEIGHT - XX_TABBAR_HEIGHT - blankHeight;
        if (offset > 0) {
            blankHeight += offset;
        }
        return blankHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, XX_ADJUST_SIZE(173))];
    view.backgroundColor = [UIColor whiteColor];
    if (!_segmentView) {
        _segmentView = [[LLHomeViewSegmentView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(29), 0, self.width-XX_ADJUST_SIZE(29*2), XX_ADJUST_SIZE(173))];
        [_segmentView ll_setDataList:self.segmentList];
        __weak typeof(self)weakSelf = self;
        _segmentView.LLSegmentChangeIndex = ^(NSInteger index) {
            [weakSelf ll_handleSegmentChangeIndex:index];
        };
    }
    
    [view addSubview:_segmentView];
    return view;
}

- (void)ll_handleSegmentChangeIndex:(NSInteger)index {
    NSLog(@"%d", index);
    NSString *currLabel = self.segmentList[index][@"title"];
    [self.currentList removeAllObjects];
    if ([currLabel isEqualToString:@"全部"]) {
        [self.currentList addObjectsFromArray:self.recommendList];
    } else {
        for (LLMovieModel *model in self.recommendList) {
            if (![model.labelList containsObject:currLabel]) {
                continue;
            }
            [self.currentList addObject:model];
        }
    }
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentList.count > 0) {
        return self.currentList.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentList.count > 0) {
        LLHomeRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLHomeRecommendCell"];
        if (!cell) {
            cell = [[LLHomeRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LLHomeRecommendCell"];
            cell.delegate = self;
        }
        [cell setData:self.currentList[indexPath.row]];
        return cell;
    } else {
        LLHomeRecommendNoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLHomeRecommendNoneCell"];
        if (!cell) {
            cell = [[LLHomeRecommendNoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LLHomeRecommendNoneCell"];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.currentList.count == 0) {
        return;
    }
    LLMovieModel *model = self.currentList[indexPath.row];
    __weak typeof(self)weakSelf = self;
    [[LLRouterManager shareInstance] ll_routeUrl:@"xx://home_detail" obj:model dataBack:^(id  _Nonnull obj) {
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)recommendCellDidClickActionButton:(LLHomeRecommendCell *)recommendCell {
    if (![LLUserManager isLogin]) {
        [LLUserManager ll_showLogin];
        return;
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:recommendCell];
    LLMovieModel *model = self.currentList[indexPath.row];
    if (!model.hasFlowWill) {
        model.hasFlowWill = YES;
        [JKAlert alertWaitingText:@"请求中..."];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JKAlert alertWaiting:NO];
            [JKAlert alertText:@"已将电影放到想看列表"];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        });
        return;
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确定去掉已想看的标记？" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [JKAlert alertWaitingText:@"请求中..."];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JKAlert alertWaiting:NO];
            [JKAlert alertText:@"已去掉"];
            model.hasFlowWill = NO;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        });
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertVC animated:YES completion:NULL];
}

@end
