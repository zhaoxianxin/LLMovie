//
//  LLRouterManager.h
//  LLMovie
//
//  Created by xin xian on 2021/3/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^XXDataBack)(id obj);
typedef void (^XXRouteBack)(id obj, XXDataBack dataBack);

@interface LLRouterManager : NSObject
+ (instancetype)shareInstance;
- (void)ll_registUrl:(NSString *)url routeBack:(XXRouteBack)routeBack;
- (void)ll_routeUrl:(NSString *)url obj:(id _Nullable)obj;
- (void)ll_routeUrl:(NSString *)url obj:(id _Nullable)obj dataBack:(XXDataBack _Nullable)dataBack;
@end

NS_ASSUME_NONNULL_END
