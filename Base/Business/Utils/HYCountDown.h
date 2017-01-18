//
//  HYCountDown.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYCountDown : NSObject

+ (instancetype)countDownWithWholeSecond:(NSInteger)times
                     WithEachSecondBlock:(void(^)(NSInteger currentTime)) eachSecondBlock
                   WithCompletionHandler:(void(^)()) completionHandler;
- (void)cancelTimer;

@end
