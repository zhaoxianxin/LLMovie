//
//  ZFAlbumCell.h
//  ucard
//
//  Created by 张东东 on 2018/5/8.
//  Copyright © 2018年 文博张. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFAlbumModel.h"

@interface ZFAlbumCell : UITableViewCell

@property (nonatomic, strong) UIImageView *coverImage;  //相册图片，显示相册最后一张图片
@property (nonatomic, strong) UILabel *title;           //相册标题

- (void)zf_loadDataWithModel:(ZFAlbumModel *)model;

+ (CGFloat)cellHeight;

@end
