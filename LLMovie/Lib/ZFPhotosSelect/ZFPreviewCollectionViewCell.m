//
//  ZFPreviewCollectionViewCell.m
//  ucard
//
//  Created by 张东东 on 2018/5/10.
//  Copyright © 2018年 文博张. All rights reserved.
//

#import "ZFPreviewCollectionViewCell.h"
#import "ZFPhotosSelectorHeader.h"

@implementation ZFPreviewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self zf_setUPView];
    }
    return self;
}

- (void)zf_setUPView{
    self.photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XX_SCREEN_WIDTH, XX_SCREEN_HEIGHT)];
    self.photoImage.contentMode = UIViewContentModeScaleAspectFit;
    self.photoImage.layer.masksToBounds = YES;
    [self.contentView addSubview:self.photoImage];
}

- (void)zf_loadDataWithModel:(ZFAssetModel *)model{
    if ([model.asset isKindOfClass:[PHAsset class]]) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.photoImage.image = result;
        }];
    }
}

@end
