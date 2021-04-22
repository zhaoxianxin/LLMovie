//
//  ZFAlbumListViewController.h
//  ucard
//
//  Created by 张东东 on 2018/5/8.
//  Copyright © 2018年 文博张. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFAlbumListViewController : UIViewController
///选择的数量
@property (nonatomic, assign) NSInteger selectNum;
///回调数据
@property (nonatomic, copy) void(^selectPhotoResult)(id responseObject);
@end
