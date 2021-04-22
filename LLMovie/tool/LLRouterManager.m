//
//  LLRouterManager.m
//  LLMovie
//
//  Created by xin xian on 2021/3/12.
//

#import "LLRouterManager.h"

@interface LLRouterManager()
@property(nonatomic, strong) NSMutableDictionary *routeData;
@end

@implementation LLRouterManager

+ (instancetype)shareInstance {
    static LLRouterManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[LLRouterManager alloc] init];
        shareInstance.routeData = [NSMutableDictionary dictionary];
    });
    return shareInstance;
}

- (void)ll_registUrl:(NSString *)url routeBack:(XXRouteBack)routeBack {
    self.routeData[url] = routeBack;
}

- (void)ll_routeUrl:(NSString *)url obj:(id _Nullable)obj {
    [self ll_routeUrl:url obj:obj dataBack:nil];
}

- (void)ll_routeUrl:(NSString *)url obj:(id _Nullable)obj dataBack:(XXDataBack _Nullable)dataBack {
    XXRouteBack routeBack = self.routeData[url];
    if (routeBack) {
        routeBack(obj, dataBack);
    }
}

@end
