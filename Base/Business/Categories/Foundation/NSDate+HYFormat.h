//
//  NSDate+HYFormat.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <Foundation/Foundation.h>

#define defaultInputFormat @"yyyy-MM-dd HH:mm:ss"
#define defaultOutputFormat @"MM-dd HH:mm"

@interface NSDate (HYFormat)

- (NSString *)conversationTimeString;
- (NSString *)msgTimeString;
- (int64_t)timeMillisecondSince1970;

+ (NSDate *)dateWithString:(NSString*)dateStr format:(NSString*)formatStr;
+ (NSString *)dateStringWithDate:(NSDate*)date format:(NSString*)formatStr;
+ (NSString *)dateStringWithString:(NSString *)dateStr inputFormat:(NSString*)inputFormatStr outputFormat:(NSString *)outputFormatStr;

@end
