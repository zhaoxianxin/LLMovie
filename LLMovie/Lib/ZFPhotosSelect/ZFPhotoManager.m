//
//  ZFPhotoManager.m
//  ucard
//
//  Created by 张东东 on 2018/5/7.
//  Copyright © 2018年 文博张. All rights reserved.
//

#import "ZFPhotoManager.h"
#import "ZFPhotosSelectorHeader.h"
#import "ZFAlbumModel.h"

@implementation ZFPhotoManager

+ (instancetype)shareInstance{
    static ZFPhotoManager *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[ZFPhotoManager alloc] init];
    });
    return shareManager;
}

- (NSMutableArray *)zf_getPhotoListDatas {
    NSMutableArray *albumArr = [NSMutableArray array];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    PHFetchResult *myPhotoStreamAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    PHFetchResult *sharedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];
    NSArray *allAlbums = @[myPhotoStreamAlbum,smartAlbums,topLevelUserCollections,syncedAlbums,sharedAlbums];
    for (PHFetchResult *fetchResult in allAlbums) {
        for (PHAssetCollection *collection in fetchResult) {
            // 有可能是PHCollectionList类的的对象，过滤掉
            if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count < 1) continue;
            if ([collection.localizedTitle containsString:@"Deleted"] || [collection.localizedTitle isEqualToString:@"最近删除"] || [collection.localizedTitle isEqualToString:@"视频"] || [collection.localizedTitle isEqualToString:@"Videos"] || [collection.localizedTitle isEqualToString:@"最近添加"] || [collection.localizedTitle isEqualToString:@"Recently Added"]) {
                continue;
            }
            if ([self isCameraRollAlbum:collection.localizedTitle]) {
                [albumArr insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle] atIndex:0];
            } else {
                [albumArr addObject:[self modelWithResult:fetchResult name:collection.localizedTitle]];
            }
        }
    }
    return albumArr;
}

- (ZFAlbumModel *)modelWithResult:(id)result name:(NSString *)name{
    ZFAlbumModel *model = [[ZFAlbumModel alloc] init];
    model.result = result;
    model.name = name;
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        model.count = fetchResult.count;
    }
    return model;
}

- (BOOL)isCameraRollAlbum:(NSString *)albumName {
    return [albumName isEqualToString:@"Camera Roll"] || [albumName isEqualToString:@"相机胶卷"] || [albumName isEqualToString:@"所有照片"] || [albumName isEqualToString:@"All Photos"] || [albumName isEqualToString:@"Recents"];
}

- (NSArray *)zf_getFetchResult:(id)result{
    NSMutableArray *dataArray = [NSMutableArray array];
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAsset *asset = (PHAsset *)obj;
            ZFAssetModel *model = [ZFAssetModel modelWithAsset:asset];
            [dataArray addObject:model];
        }];
        return [[dataArray reverseObjectEnumerator] allObjects];//翻转数组元素顺序
    }
    return nil;
}

-(void)zf_getImageObject:(id)asset complection:(void (^)(UIImage *, BOOL))complection{
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)asset;
        CGFloat photoWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        //屏幕分辨率 scale = 1 代表 分辨率是320 * 480; = 2 代表 分辨率是 640 * 960; = 3 代表 分辨率是 1242 * 2208
        CGFloat multiple = [UIScreen mainScreen].scale;
        CGFloat pixelWidth = photoWidth * multiple;
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        /**
         *  PHImageManager 是通过请求的方式拉取图像，并可以控制请求得到的图像的尺寸、剪裁方式、质量，缓存以及请求本身的管理（发出请求、取消请求）等
         *
         *  @param pixelWidth 获取图片的宽
         *  @param pixelHeight 获取图片的高
         *  @param contentMode 图片的剪裁方式
         *
         *  @return
         */
        [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            // 排除取消，错误，低清图三种情况，即已经获取到了高清图
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined) {
                //回调
                if (complection){
                    complection(result,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                }
            }
            
        }];
    }
}

@end
