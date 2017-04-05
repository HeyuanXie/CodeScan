//
//  APIHelper+Theater.h
//  Base
//
//  Created by admin on 2017/3/29.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper.h"

@interface APIHelper (Theater)

-(void)theaterHotCitysComplete:(ApiRequestCompleteBlock)complete;

-(void)theaterListStart:(NSInteger)start
                  limit:(NSInteger)limit
                classId:(NSInteger)classId
                orderBy:(NSString*)orderBy
              orderType:(NSString*)orderType
                   city:(NSString*)city
               complete:(ApiRequestCompleteBlock)complete;

-(void)theaterDetail:(NSInteger)playId complete:(ApiRequestCompleteBlock)complete;

-(void)theaterSession:(NSInteger)start
                limit:(NSInteger)limit
               playId:(NSInteger)playId
                 date:(NSString*)date
             complete:(ApiRequestCompleteBlock)complete;

-(void)theaterSeatDetail:(NSInteger)hallId
                  timeId:(NSInteger)timeId
                complete:(ApiRequestCompleteBlock)complete;

-(void)theaterSeatLock:(NSInteger)timeId
                 seats:(NSArray*)seats
              complete:(ApiRequestCompleteBlock)complete;

-(void)theaterCommitOrder:(NSInteger)timeId
                  payType:(NSInteger)payType
                   cardSn:(NSString*)cardSn
                 couponSn:(NSString*)couponSn
                    seats:(NSArray*)seats
                 complete:(ApiRequestCompleteBlock)complete;

-(void)theaterComment:(NSInteger)playId
              orderId:(NSString*)orderId
                score:(NSInteger)score
              content:(NSString*)content
               images:(NSArray*)images
             complete:(ApiRequestCompleteBlock)complete;

@end
