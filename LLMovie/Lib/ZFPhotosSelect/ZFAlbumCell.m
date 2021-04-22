//
//  ZFAlbumCell.m
//  ucard
//
//  Created by 张东东 on 2018/5/8.
//  Copyright © 2018年 文博张. All rights reserved.
//

#import "ZFAlbumCell.h"
#import "ZFPhotosSelectorHeader.h"

@implementation ZFAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self zf_setUpView];
    }
    return self;
}

- (void)zf_setUpView{
    self.coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(20), XX_ADJUST_SIZE(20), XX_ADJUST_SIZE(160), XX_ADJUST_SIZE(160))];
    self.coverImage.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImage.layer.masksToBounds = YES;
    [self.contentView addSubview:self.coverImage];
    self.title = [[UILabel alloc] init];
    self.title.textColor = UIColorFromString(@"666666");
    self.title.font = XX_SYSTEM_FONT(50);
    [self.contentView addSubview:self.title];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(180), XX_ADJUST_SIZE(200)- 1/[UIScreen mainScreen].scale, XX_SCREEN_WIDTH-XX_ADJUST_SIZE(180), 1 / [UIScreen mainScreen].scale)];
    line.backgroundColor = UIColorFromString(@"dcdcdc");
    [self.contentView addSubview:line];
}

- (void)zf_loadDataWithModel:(ZFAlbumModel *)model{
    if ([model.result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *result = (PHFetchResult *)model.result;
        [[PHImageManager defaultManager] requestImageForAsset:[result lastObject] targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result == nil) {
                self.coverImage.image = nil;
            }else{
                self.coverImage.image = result;
            }
        }];
    }
    self.title.text = [NSString stringWithFormat:@"%@(%ld)",model.name,(long)model.count];
    [self.title sizeToFit];
    self.title.left = self.coverImage.right+XX_ADJUST_SIZE(40);
    self.title.centerY = self.coverImage.centerY;
}



+ (CGFloat)cellHeight{
    return XX_ADJUST_SIZE(200);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
