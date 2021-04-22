//
//  LLReportViewController.m
//  LLMovie
//
//  Created by xin xian on 2021/3/13.
//

#import "LLReportViewController.h"
#import "LLMovieModel.h"
#import "LLCircleModel.h"

@interface LLReportItemCell : UITableViewCell
@property (nonatomic, strong) UIImageView *selectImage;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation LLReportItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(XX_SCREEN_WIDTH-XX_ADJUST_SIZE(46+69), XX_ADJUST_SIZE(46), XX_ADJUST_SIZE(69), XX_ADJUST_SIZE(69))];
        [self addSubview:self.selectImage=selectImage];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(43), 0, XX_SCREEN_WIDTH/2, XX_ADJUST_SIZE(161))];
        titleLabel.textColor = UIColorFromString(@"222222");
        titleLabel.font = XX_SYSTEM_FONT(43);
        [self addSubview:self.titleLabel=titleLabel];
        
    }
    return self;
}

- (void)setData:(NSString *)title select:(BOOL)isSelect {
    self.titleLabel.text = title;
    self.selectImage.image = [UIImage imageNamed:isSelect?@"report_select_selected":@"report_select_none"];
}

@end

@interface LLReportViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray <NSMutableDictionary *> *reportDataList;
@property (nonatomic, strong) UIButton *reportButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentSelect;
@end

@implementation LLReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"举报" showBack:YES];
    self.reportDataList = [NSMutableArray array];
    
    [self.reportDataList addObjectsFromArray:@[
        [@{@"select":@1, @"title":@"骚扰广告"} mutableCopy],
        [@{@"select":@0, @"title":@"诈骗"} mutableCopy],
        [@{@"select":@0, @"title":@"色情低俗"} mutableCopy],
        [@{@"select":@0, @"title":@"恶意骚扰"} mutableCopy],
        [@{@"select":@0, @"title":@"不良内容、其他"} mutableCopy]
    ]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, XX_NAVIGATION_HEIGHT, self.view.width, XX_SCREEN_HEIGHT-XX_NAVIGATION_HEIGHT-XX_SAFE_BOTTOM) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [self ll_createFooterView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView=tableView];
    
}

- (UIView *)ll_createFooterView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, XX_ADJUST_SIZE(127+114*2))];
    
    UIButton *reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reportButton.frame = CGRectMake((view.width-XX_ADJUST_SIZE(346))/2, XX_ADJUST_SIZE(114), XX_ADJUST_SIZE(346), XX_ADJUST_SIZE(127));
    [reportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reportButton setTitle:@"举报" forState:UIControlStateNormal];
    reportButton.titleLabel.font = XX_SYSTEM_FONT(43);
    reportButton.layer.cornerRadius = reportButton.height/2;
    reportButton.layer.masksToBounds = YES;
    reportButton.layer.backgroundColor = [UIColorFromString(@"252525") CGColor];
    
    [reportButton addTarget:self action:@selector(ll_clickReport) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.reportButton=reportButton];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reportDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLReportItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLReportItemCell"];
    if (!cell) {
        cell = [[LLReportItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LLReportItemCell"];
    }
    NSMutableDictionary *dict = self.reportDataList[indexPath.row];
    [cell setData:dict[@"title"] select:[dict[@"select"] boolValue]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.currentSelect == indexPath.row) {
        return;
    }
    
    NSMutableDictionary *preDic = self.reportDataList[self.currentSelect];
    preDic[@"select"] = @0;
    
    NSMutableDictionary *currDic = self.reportDataList[indexPath.row];
    currDic[@"select"] = @1;
    
    self.currentSelect = indexPath.row;
    [self.tableView reloadData];
}

- (void)ll_clickReport {
    //弹框提示去举报
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定举报吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self ll_gotoReport];
    }]];
    [self presentViewController:alertVC animated:YES completion:NULL];
}

- (void)ll_gotoReport {
    [JKAlert alertWaitingText:@"请求中..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JKAlert alertWaiting:NO];
        [JKAlert alertText:@"举报成功!"];
        [self xx_clickClose];
    });
}

- (void)xx_clickClose {
    [self.navigationController popViewControllerAnimated:YES];
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
