//
//  NSDate+Ex.h
//  DIYCamera
//
//  Created by Billy Pang on 2018/9/4.
//  Copyright © 2018年 Billy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Ex)

//获取本地当前时间
+ (NSDate *) getCurrentLocalDate;

/**
 获取某日期的之前或之后的日期  正数表示未来 负数表示过去  多少年  多少个月 多少天
 */
+(NSDate*) getSomeDate:(NSDate*) beginDate year:(int) year month:(int) month day:(int) day;

/**
 返回日期是 星期几
 */
+(NSString*) weekdayStringFromDate:(NSDate*)inputDate;

/**
 日期比较
 返回 1 表示当前日期比baseDay 大
 返回 -1 表示当前日期 比 baseDay 小
 返回 0 表示同一天
 */
+ (int) compareOneDay:(NSDate *)currentDay withAnotherDay:(NSDate *)BaseDay;


+(NSString*) getCurrentTimeStamp;

+(NSString*) getCurrentMilliTimeStamp;

+ (NSString *) getMonthLastDayWith:(NSString *)dateStr;

+ (NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month;

+ (NSString*) currentDay;

/**将时间戳转换为时间*/
+ (NSDate *)timestampToDate:(double)timestamp;

@end
