//
//  NSDate+HYFormat.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HYFormat)

- (NSString *)conversationTimeString;
- (NSString *)msgTimeString;
- (int64_t)timeMillisecondSince1970;

@end
