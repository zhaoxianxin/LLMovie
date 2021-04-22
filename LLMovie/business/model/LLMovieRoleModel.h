//
//  LLMovieRoleModel.h
//  LLMovie
//
//  Created by xin xian on 2021/3/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLMovieRoleModel : NSObject
@property (nonatomic, assign) int modelId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, copy) NSString *roleName;
@end

NS_ASSUME_NONNULL_END
