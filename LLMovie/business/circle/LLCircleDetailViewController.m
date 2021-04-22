//
//  LLCircleDetailViewController.m
//  LLMovie
//
//  Created by xin xian on 2021/3/14.
//

#import "LLCircleDetailViewController.h"
#import "LLMovieCommentModel.h"
#import <MJRefresh/MJRefresh.h>
#import "LLCircleListCell.h"
#import "LLDetailCommentCell.h"
#import "LLDetailInputView.h"
#import "HZYImageScanView.h"

@interface LLCircleDetailViewController () <UITableViewDelegate, UITableViewDataSource, LLCircleListCellDelegate, HZYImageScanViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LLDetailInputView *bottomView;
@property (nonatomic, copy) NSIndexPath *scanPath;
@end

@implementation LLCircleDetailViewController

- (NSMutableArray <LLMovieCommentModel *> *)commentList {
    return self.model.commentList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"" showBack:YES];
    [self.naView setRightImage:[UIImage imageNamed:@"circle_list_report"]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, XX_NAVIGATION_HEIGHT, self.view.width, XX_SCREEN_HEIGHT-XX_SAFE_BOTTOM-XX_NAVIGATION_HEIGHT-XX_ADJUST_SIZE(161)) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView=tableView];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    LLDetailInputView *bottomView = [[LLDetailInputView alloc] initWithFrame:CGRectMake(0, XX_SCREEN_HEIGHT-XX_ADJUST_SIZE(161)-XX_SAFE_BOTTOM, self.view.width, XX_ADJUST_SIZE(161)+XX_SAFE_BOTTOM)];
    [bottomView.sendButton addTarget:self action:@selector(xx_clickSend) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomView=bottomView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xx_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xx_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)xx_clickSend {
    if (![LLUserManager isLogin]) {
        [LLUserManager ll_showLogin];
        self.bottomView.bottomInput.text = nil;
        return;
    }
    if (self.bottomView.bottomInput.text.length == 0) {
        [JKAlert alertText:@"请输入内容"];
        return;
    }
    [self.view endEditing:NO];
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
    
    [self.commentList addObject:model];
    [self.tableView reloadData];
    
    self.bottomView.bottomInput.text = nil;
    
    if (self.DeleteCallBack) {
        self.DeleteCallBack(@{
            @"type": @0,
        });
    }
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

- (void)rightClick {
    if ([self.model ll_isSelf]) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.DeleteCallBack) {
                self.DeleteCallBack(@{
                    @"type": @1,
                });
            }
            [JKAlert alertText:@"已删除"];
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertVC animated:YES completion:NULL];
    } else {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[LLRouterManager shareInstance] ll_routeUrl:@"xx://report" obj:self.model];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"拉黑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self xx_handleDelteAlert:self.model];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertVC animated:YES completion:NULL];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.commentList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01; }

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section { return nil; }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    } else {
        return XX_ADJUST_SIZE(29+49+20);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section==0) {
        return nil;
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, XX_ADJUST_SIZE(29+49+20))];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(46), XX_ADJUST_SIZE(29), view.width/2, XX_ADJUST_SIZE(49))];
        title.text = [NSString stringWithFormat:@"最新评论(%d)", (int)self.model.commentCount];
        title.font = XX_SYSTEM_FONT(35);
        title.textColor = UIColorFromString(@"222222");
        [view addSubview:title];
        
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.model.xx_cellHeight;
    } else {
        LLMovieCommentModel *model = self.commentList[indexPath.row];
        return XX_ADJUST_SIZE(230-58) + model.ll_contentHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LLCircleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CircleDetailCell"];
        if (!cell) {
            cell = [[LLCircleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CircleDetailCell"];
            cell.delegate = self;
            [cell ll_setInDetail];
        }
        [cell setData:self.model];
        return cell;
    } else {
        LLDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLDetailCommentCell"];
        if (!cell) {
            cell = [[LLDetailCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LLDetailCommentCell"];
            [cell ll_setHideLine];
        }
        [cell setData:self.commentList[indexPath.row]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)cellClickImage:(LLCircleListCell *)cell imageView:(UIImageView *)imageView {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.scanPath = indexPath;
    [HZYImageScanView showWithImages:self.model.imageList beginIndex:imageView.tag-1000 deletable:NO delegate:self];
}

- (CGRect)imageViewFrameAtIndex:(NSUInteger)index forScanView:(HZYImageScanView *)scanView {
    LLCircleListCell *cell = [self.tableView cellForRowAtIndexPath:self.scanPath];
    UIImageView *imageView = [cell ll_imageViewForIndex:index];
    return [imageView.superview convertRect:imageView.frame toView:UIApplication.sharedApplication.delegate.window];
}

- (void)cellClickCollect:(LLCircleListCell *)cell {
    self.model.isCollect = !self.model.isCollect;
    [JKAlert alertText:self.model.isCollect?@"已点赞":@"已取消"];
    [cell setData:self.model];
    
    if (self.DeleteCallBack) {
        self.DeleteCallBack(@{
            @"type": @0,
        });
    }
}

- (void)cellClickComment:(LLCircleListCell *)cell {
    [self.bottomView.bottomInput becomeFirstResponder];
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:NO];
    self.bottomView.bottomInput.text = nil;
}

@end
