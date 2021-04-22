//
//  ZFPreviewCollectionViewCell.h
//  ucard
//
//  Created by 张东东 on 2018/5/10.
//  Copyright © 2018年 文博张. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFAlbumModel.h"

@interface ZFPreviewCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *photoImage;

- (void)zf_loadDataWithModel:(ZFAssetModel *)model;

@end
