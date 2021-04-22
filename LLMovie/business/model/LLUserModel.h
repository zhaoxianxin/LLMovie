//
//  LLUserModel.h
//  LLMovie
//
//  Created by xin xian on 2021/3/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLUserModel : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, copy) NSString *userBack;
@property (nonatomic, assign) NSInteger praiseCount;
@property (nonatomic, strong) UIImage *userImageData;
@end

NS_ASSUME_NONNULL_END
