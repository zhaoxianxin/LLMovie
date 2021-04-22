//
//  ZFPhotoPikerViewController.h
//  ucard
//
//  Created by 张东东 on 2018/5/8.
//  Copyright © 2018年 文博张. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFPhotosSelectorHeader.h"

@interface ZFPhotoPikerViewController : UIViewController

@property (nonatomic, assign) BOOL isAutoSelect;
///选择的数量
@property (nonatomic, assign) NSInteger selectNumMax;
///数据回调
@property (nonatomic, copy) void(^selectPhotoResult)(id responseObject);
@property (strong, nonatomic) PHFetchResult *fetch;
@property (nonatomic, copy) NSString *albumTitle; // 相册名称
@end
