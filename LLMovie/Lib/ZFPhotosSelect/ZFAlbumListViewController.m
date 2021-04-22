//
//  ZFAlbumListViewController.m
//  ucard
//
//  Created by 张东东 on 2018/5/8.
//  Copyright © 2018年 文博张. All rights reserved.
//

#import "ZFAlbumListViewController.h"
#import "ZFAlbumCell.h"
#import "ZFPhotoPikerViewController.h"
#import "ZFPhotoManager.h"

@interface ZFAlbumListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *albumTableView;
@property (nonatomic, strong) NSMutableArray *albumList;
@property (nonatomic, strong) UIBarButtonItem *cancleBtn;
@end

@implementation ZFAlbumListViewController

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"照片";
    self.navigationItem.rightBarButtonItem = self.cancleBtn;
    [self zf_setUpView];
    [self zf_loadAlbumData];
}

- (void)zf_setUpView{
    [self.view addSubview:self.albumTableView];
}

- (void)zf_loadAlbumData{
    self.albumList = [[ZFPhotoManager shareInstance] zf_getPhotoListDatas];
    [self.albumTableView reloadData];
}

#pragma mark
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ZFAlbumCell cellHeight];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.albumList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZFAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZFAlbumCell"];
    if (cell == nil) {
        cell = [[ZFAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZFAlbumCell"];
    }
    ZFAlbumModel *model = (ZFAlbumModel *)[self.albumList objectAtIndex:indexPath.row];
    [cell zf_loadDataWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZFAlbumModel *model = (ZFAlbumModel *)[self.albumList objectAtIndex:indexPath.row];
    ZFPhotoPikerViewController *photoPikerVC = [[ZFPhotoPikerViewController alloc] init];
    photoPikerVC.selectPhotoResult = self.selectPhotoResult;
    photoPikerVC.selectNumMax = self.selectNum;
    photoPikerVC.isAutoSelect = NO;
    photoPikerVC.fetch = model.result;
    photoPikerVC.albumTitle = model.name;
    [self.navigationController pushViewController:photoPikerVC animated:YES];
}

#pragma mark TOUCH ACTION
- (void)touchCancleAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark SET OR GET
- (UITableView *)albumTableView{
    if (_albumTableView == nil) {
        _albumTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XX_SCREEN_WIDTH, XX_SCREEN_HEIGHT) style:UITableViewStylePlain];
        _albumTableView.delegate = self;
        _albumTableView.dataSource = self;
        _albumTableView.separatorStyle = NO;
    }
    return _albumTableView;
}

-(UIBarButtonItem *)cancleBtn{
    if (nil == _cancleBtn) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
        [button addTarget:self action:@selector(touchCancleAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromString(@"007aff") forState:UIControlStateNormal];
        _cancleBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _cancleBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
