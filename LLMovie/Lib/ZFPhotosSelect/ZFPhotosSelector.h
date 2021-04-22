//
//  ZFPhotosSelector.h
//  ucard
//
//  Created by 张东东 on 2018/5/9.
//  Copyright © 2018年 文博张. All rights reserved.
//

#import <UIKit/UIKit.h>
///图片选择器
@interface ZFPhotosSelector : NSObject
///可选择的图片数量
@property (nonatomic, assign) NSInteger selectPhotoOfMax;
///开始选择 （需要先判断是否有系统权限）
///@param controller 源vc
///@param result 选择的结果回调
- (void)zf_showIn:(UIViewController *)controller result:(void(^)(id responseObject))result;
@end
