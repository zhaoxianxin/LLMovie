//
//  ZFPhotosSelector.m
//  ucard
//
//  Created by 张东东 on 2018/5/9.
//  Copyright © 2018年 文博张. All rights reserved.
//

#import "ZFPhotosSelector.h"
#import "ZFAlbumListViewController.h"
#import "ZFPhotoPikerViewController.h"

@interface ZFPhotosSelector ()
@property (nonatomic, strong) ZFAlbumListViewController *albumListVC;
@property (nonatomic, strong) UINavigationController *photoListNavigationController;
@property (nonatomic, strong) ZFPhotoPikerViewController *photoPikerVC;
@end

@implementation ZFPhotosSelector

///开始选择 （需要先判断是否有系统权限）
///param controller源vc
///param result选择的结果回调
- (void)zf_showIn:(UIViewController *)controller result:(void(^)(id responseObject))result {
    self.albumListVC.selectPhotoResult = result;
    self.albumListVC.selectNum = self.selectPhotoOfMax;
    [self zf_showPhotoList:controller];
    
    self.photoPikerVC.selectPhotoResult = result;
    self.photoPikerVC.selectNumMax = self.selectPhotoOfMax;
    self.photoPikerVC.isAutoSelect = YES;
    [self zf_showPhotoPikerView];
}

- (void)zf_showPhotoList:(UIViewController *)controller{
    [controller presentViewController:self.photoListNavigationController animated:YES completion:nil];
}

- (void)zf_showPhotoPikerView{
    [self.photoListNavigationController pushViewController:self.photoPikerVC animated:NO];
}

#pragma SET OR GET
- (ZFAlbumListViewController *)albumListVC{
    if (nil == _albumListVC) {
        _albumListVC = [[ZFAlbumListViewController alloc] init];
    }
    return _albumListVC;
}

- (UINavigationController *)photoListNavigationController{
    if (nil == _photoListNavigationController) {
        _photoListNavigationController = [[UINavigationController alloc] initWithRootViewController:self.albumListVC];
        _photoListNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return _photoListNavigationController;
}

- (ZFPhotoPikerViewController *)photoPikerVC{
    if (nil == _photoPikerVC) {
        _photoPikerVC = [[ZFPhotoPikerViewController alloc] init];
    }
    return _photoPikerVC;
}

@end
