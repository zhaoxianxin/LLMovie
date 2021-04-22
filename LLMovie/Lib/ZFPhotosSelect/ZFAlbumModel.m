//
//  ZFAlbumModel.m
//  ucard
//
//  Created by 张东东 on 2018/5/7.
//  Copyright © 2018年 文博张. All rights reserved.
//

#import "ZFAlbumModel.h"

@implementation ZFAssetModel
+ (instancetype)modelWithAsset:(id)asset{
    ZFAssetModel *model = [[ZFAssetModel alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    return model;
}
@end

@implementation ZFAlbumModel

- (NSString *)description{
    return [NSString stringWithFormat:@"相册名称-%@ 相册个数%ld",self.name,(long)self.count];
}

@end
