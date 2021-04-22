//
//  ZFPreViewPhotoViewController.m
//  ucard
//
//  Created by 张东东 on 2018/5/10.
//  Copyright © 2018年 文博张. All rights reserved.
//

#define kZFHeadViewLeftMargin 15

#import "ZFPreViewPhotoViewController.h"
#import "ZFPreviewCollectionViewCell.h"
#import "ZFPhotosSelectorHeader.h"
#import "ZFAlbumModel.h"

@interface ZFPreViewPhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *previewCollectionView;
@property (nonatomic, strong) NSMutableArray *photoDataArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *completeBtn;
@property (nonatomic, strong) NSIndexPath *currentIndex;
@property (nonatomic, assign) BOOL showHead;
@property (nonatomic, strong) UIButton *sureBtn;
@end

@implementation ZFPreViewPhotoViewController

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.dataArray = [NSMutableArray array];
    self.showHead = YES;
    [self setUpView];
    [self loadData];
}

- (void)loadData{
    [self.dataArray addObjectsFromArray:self.selectArray];
    [self.previewCollectionView reloadData];
}

#pragma mark UI

- (void)setUpView{
    [self.view addSubview:self.previewCollectionView];
    [self.view addSubview:self.headView];
    [self.headView addSubview:self.selectBtn];
    self.selectBtn.right = XX_SCREEN_WIDTH;
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.sureBtn];
    [self zf_updateButtonStatusWithCount:self.selectArray.count];
}

#pragma mark UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZFPreviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZFPreviewCollectionViewCell" forIndexPath:indexPath];
    ZFAssetModel *model = (ZFAssetModel *)[self.dataArray objectAtIndex:indexPath.row];
    [cell zf_loadDataWithModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.showHead == YES) {
        [self headAnimation];
        self.showHead = NO;
    }else{
        [self headAnimation];
        self.showHead = YES;
    }
}

- (void)headAnimation{
    if (self.showHead == YES) {
        [UIView animateWithDuration:0.2 animations:^{
            self.headView.frame = CGRectMake(0, -XX_NAVIGATION_HEIGHT, XX_SCREEN_WIDTH, XX_NAVIGATION_HEIGHT);
        }];
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomView.frame = CGRectMake(0, XX_SCREEN_HEIGHT, XX_SCREEN_WIDTH, XX_TABBAR_HEIGHT);
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.headView.frame = CGRectMake(0, 0, XX_SCREEN_WIDTH, XX_NAVIGATION_HEIGHT);
        }];
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomView.frame = CGRectMake(0, XX_SCREEN_HEIGHT-XX_TABBAR_HEIGHT, XX_SCREEN_WIDTH, XX_TABBAR_HEIGHT);
        }];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    self.currentIndex = indexPath;
    ZFAssetModel *model = (ZFAssetModel *)[self.dataArray objectAtIndex:indexPath.row];
    [self setSelectBtnWithModel:model];
}

- (void)setSelectBtnWithModel:(ZFAssetModel *)model{
    if (model.isSelected == YES) {
        [self.selectBtn setImage:ZF_SELECT_PHOTO_IMAGE forState:UIControlStateNormal];
        self.selectBtn.selected = YES;
    }else{
        [self.selectBtn setImage:ZF_UNSELECT_PHOTO_IMAGE forState:UIControlStateNormal];
        self.selectBtn.selected = NO;
    }
}

#pragma mark SET OR GET
- (UICollectionView *)previewCollectionView{
    if (_previewCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(XX_SCREEN_WIDTH, XX_SCREEN_HEIGHT);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _previewCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, XX_SCREEN_WIDTH, XX_SCREEN_HEIGHT) collectionViewLayout:layout];
        _previewCollectionView.backgroundColor = [UIColor clearColor];
        _previewCollectionView.pagingEnabled = YES;
        _previewCollectionView.showsVerticalScrollIndicator = NO;
        _previewCollectionView.showsHorizontalScrollIndicator = NO;
        [_previewCollectionView registerClass:[ZFPreviewCollectionViewCell class] forCellWithReuseIdentifier:@"ZFPreviewCollectionViewCell"];
        _previewCollectionView.delegate = self;
        _previewCollectionView.dataSource = self;
    }
    return _previewCollectionView;
}

- (UIView *)headView{
    if (_headView == nil) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XX_SCREEN_WIDTH, XX_NAVIGATION_HEIGHT)];
        _headView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, XX_SAFE_TOP, 40, _headView.height - XX_SAFE_TOP);
        [backBtn setImage:[UIImage xx_imageWithFileName:@"zf_photo_selector_white_back@3x"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(touchBackAction:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:backBtn];
    }
    return _headView;
}

- (UIButton *)selectBtn{
    if (nil == _selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake(0, XX_SAFE_TOP, 40, self.headView.height-XX_SAFE_TOP);
        _selectBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_selectBtn addTarget:self action:@selector(touchSelectBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, XX_SCREEN_HEIGHT-XX_TABBAR_HEIGHT, XX_SCREEN_WIDTH, XX_TABBAR_HEIGHT)];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _bottomView;
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

- (void)touchCompleteAction:(id)sender {
    if (self.clickSureCallBack) {
        self.clickSureCallBack();
    }
}

#pragma mark TOUCH ACTION
- (void)touchBackAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchSelectBtn{
    ZFAssetModel *model = (ZFAssetModel *)[self.dataArray objectAtIndex:self.currentIndex.row];
    if (self.selectBtn.selected == YES) {
        model.isSelected = NO;
        [self.selectBtn setImage:ZF_UNSELECT_PHOTO_IMAGE forState:UIControlStateNormal];
        self.selectBtn.selected = NO;
    }else{
        model.isSelected = YES;
        self.selectBtn.selected = YES;
        [self.selectBtn setImage:ZF_SELECT_PHOTO_IMAGE forState:UIControlStateNormal];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(preViewController:didSelectItem:)]) {
        NSInteger count = [self.delegate preViewController:self didSelectItem:model];
        [self zf_updateButtonStatusWithCount:count];
    }
}

- (void)zf_updateButtonStatusWithCount:(NSInteger)count {
    if (count==0) {
        [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:UIColorFromString(@"999999") forState:UIControlStateNormal];
        self.sureBtn.backgroundColor = UIColorFromString(@"EBEBEB");
        self.sureBtn.userInteractionEnabled = NO;
    } else {
        [self.sureBtn setTitle:[NSString stringWithFormat:@"确定(%ld)", (long)count] forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sureBtn.backgroundColor = UIColorFromString(@"126FFB");
        self.sureBtn.userInteractionEnabled = YES;
    }
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
