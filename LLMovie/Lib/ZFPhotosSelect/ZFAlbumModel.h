//
//  ZFAlbumModel.h
//  ucard
//
//  Created by 张东东 on 2018/5/7.
//  Copyright © 2018年 文博张. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFAssetModel : NSObject
@property (nonatomic, strong) id asset;             //PHAsset or ALAsset
@property (nonatomic, assign) BOOL isSelected;      //The select status of a photo, default is No
+ (instancetype)modelWithAsset:(id)asset;
@end

@interface ZFAlbumModel : NSObject
@property (nonatomic, strong) NSString *name;   //The album name
@property (nonatomic, assign) NSInteger count;  //Count of photos the album  contain
@property (nonatomic, strong) id result;        //PHFetchResult<PHAsset> or ALAssetsGroup<ALAsset>
@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) NSArray *selectedModels;
@property (nonatomic, assign) NSUInteger selectedCount;

@end
