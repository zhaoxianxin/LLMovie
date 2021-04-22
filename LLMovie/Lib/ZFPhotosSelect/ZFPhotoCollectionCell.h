//
//  ZFPhotoCollectionCell.h
//  ucard
//
//  Created by 张东东 on 2018/5/9.
//  Copyright © 2018年 文博张. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFAlbumModel.h"

@interface ZFPhotoCollectionCell : UICollectionViewCell
@property (nonatomic, strong, readonly) UIButton *selectBtn;
- (void)zf_loadPhotoData:(ZFAssetModel *)model;
- (void)zf_updateSelect:(BOOL)isSelect;
@end
