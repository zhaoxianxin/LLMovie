//
//  ZFPhotoPikerViewController.m
//  ucard
//
//  Created by 张东东 on 2018/5/8.
//  Copyright © 2018年 文博张. All rights reserved.
//

#import "ZFPhotoPikerViewController.h"
#import "ZFPhotoManager.h"
#import "ZFPhotoCollectionCell.h"
#import "ZFPreViewPhotoViewController.h"

@interface ZFPhotoPikerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, ZFPreViewPhotoViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *previewBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIBarButtonItem *cancelBtn;
@end

@implementation ZFPhotoPikerViewController

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.photoCollectionView reloadData];
    [self zf_updateButtonStatus];
}

- (void)zf_updateButtonStatus {
    if (self.selectArray.count==0) {
        [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:UIColorFromString(@"999999") forState:UIControlStateNormal];
        self.sureBtn.backgroundColor = UIColorFromString(@"EBEBEB");
        self.sureBtn.userInteractionEnabled = NO;
    } else {
        [self.sureBtn setTitle:[NSString stringWithFormat:@"确定(%ld)", (long)self.selectArray.count] forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sureBtn.backgroundColor = UIColorFromString(@"126FFB");
        self.sureBtn.userInteractionEnabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.albumTitle && [self.albumTitle isKindOfClass:[NSString class]] && self.albumTitle.length>0) {
        self.title = self.albumTitle;
    } else {
        self.title = @"所有照片";
    }
    self.selectArray = [NSMutableArray array];
    self.navigationItem.rightBarButtonItem = self.cancelBtn;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{
        NSFontAttributeName:XX_SYSTEM_FONT(54),
        NSForegroundColorAttributeName:UIColorFromString(@"222222")
    }];
    
    //配置返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage xx_imageWithFileName:@"zf_nav_back@3x"] forState:UIControlStateNormal];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    //设置导航栏背景图片为一个白色的image
    [self.navigationController.navigationBar setBackgroundImage:[UIImage xx_imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.translucent = YES;
    
    //创建视图
    [self setUpUI];
    [self loadPhotoData];
}

- (void)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpUI{
    [self.view addSubview:self.photoCollectionView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.previewBtn];
    [self.bottomView addSubview:self.sureBtn];
}

- (void)loadPhotoData{
    ZFPhotoManager *manager = [ZFPhotoManager shareInstance];
    if (self.isAutoSelect == YES) {
        //第一次进来
        NSArray *albumArray = [manager zf_getPhotoListDatas];
        ZFAlbumModel *resultModel = (ZFAlbumModel *)[albumArray firstObject];
        //设置标题
        if ([resultModel.name isKindOfClass:[NSString class]] && resultModel.name.length>0) {
            self.title = resultModel.name;
        }
        self.dataArray = [NSMutableArray arrayWithArray:[manager zf_getFetchResult:resultModel.result]];
    }else{
        self.dataArray = [NSMutableArray arrayWithArray:[manager zf_getFetchResult:self.fetch]];
    }
    [self.photoCollectionView reloadData];
}

#pragma mark UICollectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZFPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZFPhotoCollectionCell" forIndexPath:indexPath];
    cell.selectBtn.tag = 1000+indexPath.row;
    ZFAssetModel *assetModel = (ZFAssetModel *)[self.dataArray objectAtIndex:indexPath.row];
    [cell zf_loadPhotoData:assetModel];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    ZFPhotoCollectionCell *cell = (ZFPhotoCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ZFAssetModel *selectModel = (ZFAssetModel *)[self.dataArray objectAtIndex:indexPath.row];
    if (selectModel.isSelected == NO) {
        if (self.selectArray.count + 1 > self.selectNumMax) {
            //提示超过限制
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"您最多可以选择%ld张图片哦~",(long)self.selectNumMax] preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertVC animated:YES completion:nil];
        }else{
            [self shakeToShow:cell.selectBtn];
            selectModel.isSelected = YES;
            [self.selectArray addObject:selectModel];
            [cell zf_updateSelect:YES];
        }
    }else{
        [self shakeToShow:cell.selectBtn];
        selectModel.isSelected = NO;
        [self.selectArray removeObject:selectModel];
        [cell zf_updateSelect:NO];
    }
    [self zf_updateButtonStatus];
}

#pragma mark SET OR GET
-(UIBarButtonItem *)cancelBtn{
    if (!_cancelBtn) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 50, 44);
        [button addTarget:self action:@selector(touchCancle:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = XX_SYSTEM_FONT(42);
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromString(@"222222") forState:UIControlStateNormal];
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        _cancelBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _cancelBtn;
}
- (UIView *)bottomView{
    if (nil == _bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, XX_SCREEN_HEIGHT-XX_TABBAR_HEIGHT, XX_SCREEN_WIDTH, XX_TABBAR_HEIGHT)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XX_SCREEN_WIDTH, 1 / [UIScreen mainScreen].scale)];
        line.backgroundColor = UIColorFromString(@"dcdcdc");
        [_bottomView addSubview:line];
    }
    return _bottomView;
}
- (UIButton *)previewBtn{
    if (nil == _previewBtn) {
        _previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _previewBtn.frame = CGRectMake(0, 0, XX_ADJUST_SIZE(180), 49);
        [_previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_previewBtn setTitleColor:UIColorFromString(@"222222") forState:UIControlStateNormal];
        _previewBtn.titleLabel.font = XX_SYSTEM_FONT(42);
        [_previewBtn addTarget:self action:@selector(touchPreviewPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previewBtn;
}

- (UIButton *)sureBtn{
    if (nil == _sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(0, 0, XX_ADJUST_SIZE(234), XX_ADJUST_SIZE(90));
        _sureBtn.right = self.bottomView.width-XX_ADJUST_SIZE(48);
        _sureBtn.centerY = 49.0f/2;
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.backgroundColor = UIColorFromString(@"126FFB");
        _sureBtn.titleLabel.font = XX_SYSTEM_FONT(42);
        _sureBtn.layer.cornerRadius = XX_ADJUST_SIZE(45);
        [_sureBtn addTarget:self action:@selector(touchCompleteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UICollectionView *)photoCollectionView{
    if (nil == _photoCollectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat photoSize = (XX_SCREEN_WIDTH-XX_ADJUST_SIZE(6*3+14))/4;
        flowLayout.minimumLineSpacing = XX_ADJUST_SIZE(6);
        flowLayout.minimumInteritemSpacing = XX_ADJUST_SIZE(6);
        flowLayout.itemSize = CGSizeMake(photoSize, photoSize);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(7), 0, XX_SCREEN_WIDTH-XX_ADJUST_SIZE(14), XX_SCREEN_HEIGHT-XX_TABBAR_HEIGHT) collectionViewLayout:flowLayout];
        [_photoCollectionView registerClass:[ZFPhotoCollectionCell class] forCellWithReuseIdentifier:@"ZFPhotoCollectionCell"];
        _photoCollectionView.delegate = self;
        _photoCollectionView.dataSource = self;
        _photoCollectionView.backgroundColor = UIColorFromString(@"F7F9FC");
    }
    return _photoCollectionView;
}

#pragma mark TOUCH ACTION
- (void)touchCancle:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchCompleteAction:(id)sender{
    NSMutableArray *realSelectArray = [NSMutableArray array];
    for (ZFAssetModel *model in self.selectArray) {
        if (model.isSelected == YES) {
            [realSelectArray addObject:model];
        }
    }
    
    if (realSelectArray.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    NSMutableArray *photoArr = [NSMutableArray array];
    for (int i = 0 ; i < realSelectArray.count; i ++) {
        ZFAssetModel *model = (ZFAssetModel *)[self.selectArray objectAtIndex:i];
        [[ZFPhotoManager shareInstance] zf_getImageObject:model.asset complection:^(UIImage *photo, BOOL isDegraded) {
            if (isDegraded) {
                return;
            }
            if (photo) {
                [photoArr addObject:photo];
            }
            //只有当for循环执行到之后一个时，才调用回调方法
            if (photoArr.count < realSelectArray.count) {
                return;
            }
            //获取所有高清图片之后在返回
            if (self.selectPhotoResult) {
                self.selectPhotoResult(photoArr);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (void)touchPreviewPhotoAction:(id)semder {
    if (self.selectArray.count > 0) {
        ZFPreViewPhotoViewController *previewVC = [[ZFPreViewPhotoViewController alloc] init];
        previewVC.delegate = self;
        previewVC.selectArray = [self.selectArray copy];
        
        __weak typeof(self)weakSelf = self;
        previewVC.clickSureCallBack = ^{
            [weakSelf touchCompleteAction:nil];
        };
        [self.navigationController pushViewController:previewVC animated:YES];
    }else{
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有选中图片" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

//预览界面，点击选中，返回当前选中的数量
- (NSInteger)preViewController:(ZFPreViewPhotoViewController *)preViewController didSelectItem:(id)obj {
    ZFAssetModel *selectModel = (ZFAssetModel *)obj;
    if (selectModel.isSelected) {
        [self.selectArray addObject:selectModel];
    } else {
        [self.selectArray removeObject:selectModel];
    }
    NSInteger count = self.selectArray.count;
    [self zf_updateButtonStatus];
    return count;
}

#pragma mark - **************** 列表中按钮点击动画效果
-(void)shakeToShow:(UIButton *)button{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [button.layer addAnimation:animation forKey:nil];
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
