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

@end
