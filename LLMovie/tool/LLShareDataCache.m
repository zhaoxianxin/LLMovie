//
//  LLShareDataCache.m
//  LLMovie
//
//  Created by xin xian on 2021/3/26.
//

#import "LLShareDataCache.h"

@interface LLShareDataCache()
@property (nonatomic, strong) NSArray *nickNames;
@end

@implementation LLShareDataCache

+ (instancetype)shareInstance {
    static LLShareDataCache *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[LLShareDataCache alloc] init];
        [shareInstance ll_initData];
    });
    return shareInstance;
}

+ (void)ll_registCache {
    [LLShareDataCache shareInstance];
}

- (void)ll_initData {
    self.nickNames =  [@"湾区小白豚，唔一名，阿痴，甜西Daisy，fadeforyou，黄油小饼干，想偷懒的白糖，浅草，背锅的侠，九千落日，不二家，ara，格格酱，樱花森林1994，喵呜不停，赤子蓝梦，Yoko，一片柠檬，和风小川，巫山六月，傻帽叔，一只夜猫，雨人W，番茄没有炒蛋，凤凰集香木，机智的小蹦蹦，织梦者，吸猫的少女，迷迷小羊，浮生一梦，地球流浪者，豆豆的发现" componentsSeparatedByString:@"，"];
}

- (NSString *)ll_nickNameWithId:(NSInteger)modeId {
    NSInteger index = modeId % self.nickNames.count;
    return self.nickNames[index];
}

@end
