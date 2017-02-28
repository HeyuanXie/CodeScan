//
//  HYCountDown.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HYCountDown.h"

@interface HYCountDown ()
{
    
    NSString *_normalTitle;
    NSString *_selectedTitle;
    UIButton *_btn;
    
    dispatch_source_t timer;
}
@property (nonatomic, assign) NSInteger times;
@end

@implementation HYCountDown

+ (instancetype)shareInstance{
    HYCountDown * countdown = [[self alloc] init];
    return countdown;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark -
+ (instancetype)countDownWithWholeSecond:(NSInteger)times
                     WithEachSecondBlock:(void(^)(NSInteger currentTime)) eachSecondBlock
                   WithCompletionHandler:(void(^)()) completionHandler{
    HYCountDown *countDown = [HYCountDown shareInstance];
    [countDown startCountDownWithWholeSecond:times WithEachSecondBlock:eachSecondBlock WithCompletionHandler:completionHandler];
    return countDown;
}

- (void)startCountDownWithWholeSecond:(NSInteger)times
                  WithEachSecondBlock:(void(^)(NSInteger currentTime)) eachSecondBlock
                WithCompletionHandler:(void(^)()) completionHandler{
    _times = times;
    
    @weakify(self)
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0*NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(timer, ^{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            @strongify(self);
            if (eachSecondBlock) {
                eachSecondBlock(self.times);
            }
            
        });
        if (_times <=0) {
            
            dispatch_source_cancel(timer);
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                if (completionHandler) {
                    completionHandler();
                }
            });
        }
        _times --;
    });
    
    dispatch_resume(timer);
    
}

- (void)cancelTimer{
    dispatch_source_cancel(timer);
}

@end
