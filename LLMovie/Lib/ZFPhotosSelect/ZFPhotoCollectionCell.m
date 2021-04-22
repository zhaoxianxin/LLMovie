//
//  ZFPhotoCollectionCell.m
//  ucard
//
//  Created by 张东东 on 2018/5/9.
//  Copyright © 2018年 文博张. All rights reserved.
//

#import "ZFPhotoCollectionCell.h"
#import "ZFPhotosSelectorHeader.h"

@interface ZFPhotoCollectionCell()
@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong, readwrite) UIButton *selectBtn;
@end

@implementation ZFPhotoCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self zf_setUpView];
    }
    return self;
}

- (void)zf_setUpView{
    CGFloat photoSize = (XX_SCREEN_WIDTH-3)/4;
    self.photo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, photoSize, photoSize)];
    self.photo.layer.masksToBounds = YES;
    self.photo.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.photo];
    
    CGFloat btnSize = XX_ADJUST_SIZE(96);
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.frame = CGRectMake(photoSize-btnSize, 0, btnSize, btnSize);
    self.selectBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:self.selectBtn];
}

- (void)zf_loadPhotoData:(ZFAssetModel *)model{
    if ([model.asset isKindOfClass:[PHAsset class]]) {
        PHAsset *asset = (PHAsset *)model.asset;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.photo.image = result;
        }];
    }
    [self zf_updateSelect:model.isSelected];
}

- (void)zf_updateSelect:(BOOL)isSelect {
    if (isSelect) {
        [self.selectBtn setImage:ZF_SELECT_PHOTO_IMAGE forState:UIControlStateNormal];
    } else {
        [self.selectBtn setImage:ZF_UNSELECT_PHOTO_IMAGE forState:UIControlStateNormal];
    }
}

@end
