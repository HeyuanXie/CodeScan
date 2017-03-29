//
//  NSDate+HYFormat.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "NSDate+HYFormat.h"

@implementation NSDate (HYFormat)

- (NSString *)conversationTimeString{
    static NSDateFormatter* myFormatter=NULL;
    if (!myFormatter) {
        myFormatter = [[NSDateFormatter alloc] init];
    }
    NSString *dateStr=@"";
    NSDateComponents *selfDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra
                                 |NSCalendarUnitYear
                                 |NSCalendarUnitMonth
                                 |NSCalendarUnitDay
                                 |NSCalendarUnitHour
                                 |NSCalendarUnitMinute
                                                                fromDate:self];
    NSDateComponents *now = [[NSCalendar currentCalendar] components:NSCalendarUnitEra
                             |NSCalendarUnitYear
                             |NSCalendarUnitMonth
                             |NSCalendarUnitDay
                             |NSCalendarUnitHour
                             |NSCalendarUnitMinute
                             
                                                            fromDate:[NSDate date]];
    
    if ([now year] == [selfDay year] && [now era] == [selfDay era]) {//当年
        if([now day] == [selfDay day] &&  [now month] == [selfDay month]) {//当天
            NSTimeInterval timeInter = [self timeIntervalSinceNow]*(-1);
            if (timeInter<60) {
                dateStr=NSLocalizedString(@"刚刚", nil);
            } else {
                myFormatter.dateFormat = @"HH:mm";
                dateStr= [myFormatter stringFromDate:self];
            }
        } else {
            myFormatter.dateFormat = @"MM-dd";
            dateStr= [myFormatter stringFromDate:self];
        }
    } else {
        myFormatter.dateFormat = @"yy-MM-dd";
        dateStr= [myFormatter stringFromDate:self];
    }
    return dateStr;
}

- (NSString *)msgTimeString{
    static NSDateFormatter* myFormatter=NULL;
    if (!myFormatter) {
        myFormatter = [[NSDateFormatter alloc] init];
    }
    NSString *dateStr=@"";
    NSDateComponents *selfDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra
                                 |NSCalendarUnitYear
                                 |NSCalendarUnitMonth
                                 |NSCalendarUnitDay
                                 |NSCalendarUnitHour
                                 |NSCalendarUnitMinute
                                                                fromDate:self];
    NSDateComponents *now = [[NSCalendar currentCalendar] components:NSCalendarUnitEra
                             |NSCalendarUnitYear
                             |NSCalendarUnitMonth
                             |NSCalendarUnitDay
                             |NSCalendarUnitHour
                             |NSCalendarUnitMinute
                             
                                                            fromDate:[NSDate date]];
    
    if ([now year] == [selfDay year] && [now era] == [selfDay era]) {//当年
        if([now day] == [selfDay day] &&  [now month] == [selfDay month]) {//当天
            myFormatter.dateFormat = @"HH:mm";
            dateStr= [myFormatter stringFromDate:self];
        } else {
            myFormatter.dateFormat = @"MM-dd";
            dateStr= [myFormatter stringFromDate:self];
        }
    } else {
        myFormatter.dateFormat = @"yy-MM-dd";
        dateStr= [myFormatter stringFromDate:self];
    }
    return dateStr;
}

- (int64_t)timeMillisecondSince1970{
    return [self timeIntervalSince1970] * 1000;
}



/**
 将时间字符串转成时间戳对象

 @param dateStr 输入的时间字符串
 @param formatStr 输入的时间字符串的格式
 @return 返回的时间戳对象
 */
+ (NSDate *)dateWithString:(NSString *)dateStr format:(NSString *)formatStr {
    if (formatStr == nil) {
        formatStr = defaultInputFormat;
    }
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    format.dateFormat = formatStr;
    return [format dateFromString:dateStr];
}


/**
 将时间戳对象以某种格式转成字符串

 @param date 输入的时间戳对象
 @param formatStr 输出时间字符串格式
 @return 返回的时间字符串
 */
+ (NSString *)dateStringWithDate:(NSDate *)date format:(NSString *)formatStr {
    if (formatStr == nil) {
        formatStr = defaultOutputFormat;
    }
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    format.dateFormat = formatStr;
    return [format stringFromDate:date];
}


/**
 将某种格式时间字符串，转成另一种格式的时间字符串

 @param dateStr 时间字符串
 @param inputFormatStr 输入的时间戳格式
 @param outputFormatStr 输出的时间戳格式
 @return 返回的指定格式的时间字符串
 */
+ (NSString *)dateStringWithString:(NSString *)dateStr inputFormat:(NSString*)inputFormatStr outputFormat:(NSString *)outputFormatStr {
    if (outputFormatStr == nil) {
        outputFormatStr = defaultOutputFormat;
    }
    if (inputFormatStr == nil) {
        inputFormatStr = defaultInputFormat;
    }
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    format.dateFormat = outputFormatStr;
    return [format stringFromDate:[NSDate dateWithString:dateStr format:inputFormatStr]];
}

@end
