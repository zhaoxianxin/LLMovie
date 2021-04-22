//
//  ZFPhotoManager.h
//  ucard
//
//  Created by 张东东 on 2018/5/7.
//  Copyright © 2018年 文博张. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFPhotoManager : NSObject

+ (instancetype)shareInstance;

/**
 获取全部相册
 */
- (NSMutableArray *)zf_getPhotoListDatas;
/**
 获取某一个相册的结果集
 */
- (NSArray *)zf_getFetchResult:(id)result;

//获取图片
-(void)zf_getImageObject:(id)asset complection:(void (^)(UIImage *, BOOL))complection;

@end
