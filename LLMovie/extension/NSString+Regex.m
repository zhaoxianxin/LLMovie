//
//  NSString+Regex.m
//  LLMovie
//
//  Created by xin xian on 2021/3/17.
//

#import "NSString+Regex.h"

@implementation NSString (Regex)
- (BOOL)xx_isPhoneNumber {
    NSPredicate *regx = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1[0-9]{10}$"];
    return [regx evaluateWithObject:self];
}
- (BOOL)xx_isNumber {
    NSPredicate *regx = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\d*\\d*$"];
    return [regx evaluateWithObject:self];
}
@end

@implementation NSString (LLTime)

- (NSString *)ll_time {
    if (self.length == 0) {
        return @"";
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:self];
    return [NSString ll_showMessageTimeWithDate:date showTimeExtraStr:NO];
}

/*
 时间显示
 @param 显示额外的具体时间（消息聊天室，传YES；会话列表，传NO）
 */
+ (NSString *)ll_showMessageTimeWithDate:(NSDate *)date showTimeExtraStr:(BOOL)showExtr {
    if (!date) {
        return @"";
    }
    NSString*ret = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *curComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:currentDate];
    NSInteger currentYear = [curComponents year];
    NSInteger currentMonth = [curComponents month];
    NSInteger currentDay = [curComponents day];
    
    // 目标判断时间
    NSDateComponents *srcComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
    NSInteger srcYear = [srcComponents year];
    NSInteger srcMonth = [srcComponents month];
    NSInteger srcDay = [srcComponents day];
    // 要额外显示的时间分钟
    NSString *timeExtraStr = (showExtr?[self getTimeString:date format:@" HH:mm"]:@"");
    
    // 往年
    if(currentYear != srcYear) {
        ret = [NSString stringWithFormat:@"%@%@", [self getTimeString:date format:@"yyyy/M/d"], timeExtraStr];
        return ret;
    }
    
    // 当年
    long currentTimestamp = [self getIOSTimeStamp_l:currentDate];
    long srcTimestamp = [self getIOSTimeStamp_l:date];
    // 相差时间(单位：秒)
    long delta = currentTimestamp - srcTimestamp;
    // 当天(月份和日期一致才是)
    if(currentMonth == srcMonth && currentDay == srcDay) {
        // 时间相差60秒以内
        if(delta < 60) {
            ret = @"刚刚";
            // 否则当天其它时间段的，直接显示“时:分”的形式
        } else {
            ret = [self getTimeString:date format:@"HH:mm"];
        }
        return ret;
    }
    
    // 当年 && 当天之外的时间(即昨天及以前的时间)
    // 昨天(以“现在”的时候为基准-1天)
    NSDate *yesterdayDate = [NSDate date];
    yesterdayDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:yesterdayDate];
    NSDateComponents *yesterdayComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:yesterdayDate];
    NSInteger yesterdayMonth = [yesterdayComponents month];
    NSInteger yesterdayDay = [yesterdayComponents day];

    // 前天(以“现在”的时候为基准-2天)
    NSDate *beforeYesterdayDate = [NSDate date];
    beforeYesterdayDate = [NSDate dateWithTimeInterval:-48*60*60 sinceDate:beforeYesterdayDate];
    NSDateComponents *beforeYesterdayComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:beforeYesterdayDate];
    NSInteger beforeYesterdayMonth = [beforeYesterdayComponents month];
    NSInteger beforeYesterdayDay = [beforeYesterdayComponents day];

    // 用目标日期的“月”和“天”跟上方计算出来的“昨天”进行比较，是最为准确的(如果用时间戳差值
    // 的形式，是不准确的，比如：现在时刻是2019年02月22日1:00、而srcDate是2019年02月21日23:00，
    // 这两者间只相差2小时，直接用“delta/3600” > 24小时来判断是否昨天，就完全是扯蛋的逻辑了)
    if(srcMonth == yesterdayMonth && srcDay == yesterdayDay) {
        ret = [NSString stringWithFormat:@"昨天%@", timeExtraStr];// -1d
        // “前天”判断逻辑同上
        return ret;
    }
    
    if(srcMonth == beforeYesterdayMonth && srcDay == beforeYesterdayDay) {
        ret = [NSString stringWithFormat:@"前天%@", timeExtraStr];// -2d
        return ret;
    }
    // 跟当前时间相差的小时数
    long deltaHour = (delta/3600);
    // 如果小于或等 7*24小时就显示星期几
    if(deltaHour <= 7*24) {
        NSArray *weekdayAry = [NSArray arrayWithObjects:@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
        // 取出的星期数：1表示星期天，2表示星期一，3表示星期二。。。。 6表示星期五，7表示星期六
        NSInteger srcWeekday = [srcComponents weekday];
        // 取出当前是星期几
        NSString *weedayDesc = [weekdayAry objectAtIndex:(srcWeekday-1)];
        ret = [NSString stringWithFormat:@"%@%@", weedayDesc, timeExtraStr];
        return ret;
    }
    
    return [NSString stringWithFormat:@"%@%@", [self getTimeString:date format:@"yyyy/M/d"], timeExtraStr];
}

+ (NSString*)getTimeString:(NSDate *)dt format:(NSString *)fmt {
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:fmt];
    return [format stringFromDate:(dt==nil?[NSDate date]:dt)];
}

+ (NSTimeInterval)getIOSTimeStamp:(NSDate *)dat {
    NSTimeInterval a = [dat timeIntervalSince1970];
    return a;
}

+ (long)getIOSTimeStamp_l:(NSDate*)dat {
    return [[NSNumber numberWithDouble:[self getIOSTimeStamp:dat]] longValue];
}

@end
