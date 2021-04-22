//
//  ZFPreViewPhotoViewController.h
//  ucard
//
//  Created by 张东东 on 2018/5/10.
//  Copyright © 2018年 文博张. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZFPreViewPhotoViewControllerDelegate;
@interface ZFPreViewPhotoViewController : UIViewController
@property (nonatomic, weak) id <ZFPreViewPhotoViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *selectArray;
@property (nonatomic, copy) void(^clickSureCallBack)(void);
@end

@protocol ZFPreViewPhotoViewControllerDelegate <NSObject>
@optional
//预览界面，点击选中，返回当前选中的数量
- (NSInteger)preViewController:(ZFPreViewPhotoViewController *)preViewController didSelectItem:(id)obj;
@end
