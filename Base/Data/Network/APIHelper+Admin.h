//
//  APIHelper+Admin.h
//  Base
//
//  Created by admin on 2017/5/8.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper.h"

@interface APIHelper (Admin)

- (void)login:(NSString *)account
     password:(NSString *)pw
     complete:(ApiRequestCompleteBlock)complete;

- (void)codeScan:(NSString*)codeSn
            type:(NSInteger)type
        complete:(ApiRequestCompleteBlock)complete;

- (void)printTicket:(NSInteger)orderId
            seatIds:(NSArray*)seats
           complete:(ApiRequestCompleteBlock)complete;

- (void)deriveExchange:(NSInteger)orderId
              complete:(ApiRequestCompleteBlock)complete;

@end
