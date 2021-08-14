//
//  NSDate+Ex.m
//  DIYCamera
//
//  Created by Billy Pang on 2018/9/4.
//  Copyright © 2018年 Moses Pang. All rights reserved.
//

#import "NSDate+Ex.h"

@implementation NSDate (Ex)



+ (NSDate *) getCurrentLocalDate {
    NSDate *date = [NSDate date];
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];//或GMT
    NSTimeZone *destinationTimeZone = [NSTimeZone localTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    NSDate *destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
    return destinationDateNow;
}

/**
获取某日期的之前或之后的日期  正数表示未来 负数表示过去  多少年  多少个月 多少天
 */
+(NSDate*) getSomeDate:(NSDate*) beginDate year:(int) year month:(int) month day:(int) day {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:beginDate];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:year];
    [adcomps setMonth:month];
    [adcomps setDay:day];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:beginDate options:0];
//    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc] init];
//    [tempFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *newDateStr = [tempFormatter stringFromDate:newdate];
    return newdate;
}

+(NSString*) weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/SuZhou"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}


//日期对比
+ (int) compareOneDay:(NSDate *)currentDay withAnotherDay:(NSDate *)BaseDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
    NSString *currentDayStr = [dateFormatter stringFromDate:currentDay];
    NSString *BaseDayStr = [dateFormatter stringFromDate:BaseDay];
    NSDate *dateA = [dateFormatter dateFromString:currentDayStr];
    NSDate *dateB = [dateFormatter dateFromString:BaseDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", currentDay, BaseDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}

+(NSString*) getCurrentTimeStamp {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970];//精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

+(NSString*) getCurrentMilliTimeStamp {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

#pragma mark 获取某年某月的最后一天 dateStr yyyy-MM 格式
+ (NSString *) getMonthLastDayWith:(NSString *)dateStr {
    
    NSArray *tempArray = [dateStr componentsSeparatedByString:@"-"];
    if (tempArray.count == 2) {
        if ([tempArray[0] integerValue] > 10000) {
            return @"";
        }
        NSInteger dayCount = [NSDate howManyDaysInThisYear:[tempArray[0] integerValue] withMonth:[tempArray[1] integerValue]];
        return [NSString stringWithFormat:@"%@-%@-%ld", tempArray[0], tempArray[1], dayCount];
    } else {
        return @"";
    }
    
}

#pragma mark 获取某年某月的天数
+ (NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month {
    if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12))
        return 31 ;
    
    if((month == 4) || (month == 6) || (month == 9) || (month == 11))
        return 30;
    
    if((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3))
    {
        return 28;
    }
    
    if(year % 400 == 0)
        return 29;
    
    if(year % 100 == 0)
        return 28;
    
    return 29;
}

+ (NSString*) currentDay {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"dd"];
    NSString *hourStr = [formatter stringFromDate:[NSDate date]];
    
    return hourStr;
}

//将时间戳转换为时间
+ (NSDate *)timestampToDate:(double)timestamp {
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timestamp];
    
    //解决8小时时差问题
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
    
    
    return localeDate;
}

@end
