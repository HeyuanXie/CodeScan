//
//  APIHelper+Theater.m
//  Base
//
//  Created by admin on 2017/3/29.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper+Theater.h"

@implementation APIHelper (Theater)

/**
 剧场筛选热门城市

 @param complete <#complete description#>
 */
-(void)theaterHotCitysComplete:(ApiRequestCompleteBlock)complete {
    
    [APIHELPER getWithURL:@"movie/hotcity" param:nil complete:complete];
}


/**
 剧场列表

 @param start <#start description#>
 @param limit <#limit description#>
 @param classId <#classId description#>
 @param orderBy <#orderBy description#>
 @param orderType <#orderType description#>
 @param city <#city description#>
 @param complete <#complete description#>
 */
-(void)theaterListStart:(NSInteger)start
                  limit:(NSInteger)limit
                classId:(NSInteger)classId
                orderBy:(NSString*)orderBy
              orderType:(NSString *)orderType
                   city:(NSString *)city
               complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(start) forKey:@"start"];
    [param safe_setValue:@(limit) forKey:@"limit"];
    [param safe_setValue:@(classId) forKey:@"class_id"];
    [param safe_setValue:orderBy forKey:@"order_by"];
    [param safe_setValue:orderType forKey:@"order_type"];
    [param safe_setValue:city forKey:@"city"];
    [APIHELPER getWithURL:@"movie/index" param:param complete:complete];
    
}


/**
 剧场详情

 @param playId <#playId description#>
 @param complete <#complete description#>
 */
-(void)theaterDetail:(NSInteger)playId
            complete:(ApiRequestCompleteBlock)complete {
    
    [APIHELPER getWithURL:@"movie/detail" param:@{@"play_id":@(playId)} complete:complete];
}


/**
 剧场场次

 @param start <#start description#>
 @param limit <#limit description#>
 @param playId <#playId description#>
 @param date <#date description#>
 @param complete <#complete description#>
 */
-(void)theaterSession:(NSInteger)start
                limit:(NSInteger)limit
               playId:(NSInteger)playId
                 date:(NSString *)date
             complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(start) forKey:@"start"];
    [param safe_setValue:@(limit) forKey:@"limit"];
    [param safe_setValue:@(playId) forKey:@"play_id"];
    [param safe_setValue:date forKey:@"play_date"];
    [APIHELPER getWithURL:@"movie/playTime" param:param complete:complete];
}


/**
 剧场座位详情

 @param hallId <#hallId description#>
 @param timeId <#timeId description#>
 @param complete <#complete description#>
 */
-(void)theaterSeatDetail:(NSInteger)hallId
                  timeId:(NSInteger)timeId
                complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(hallId) forKey:@"hall_id"];
    [param safe_setValue:@(timeId) forKey:@"time_id"];
    [APIHELPER getWithURL:@"seat/detail" param:param complete:complete];
}


/**
 剧场锁定座位

 @param timeId <#timeId description#>
 @param seats <#seats description#>
 @param complete <#complete description#>
 */
-(void)theaterSeatLock:(NSInteger)timeId
                 seats:(NSArray *)seats
              complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(timeId) forKey:@"time_id"];
    [param safe_setValue:seats forKey:@"seats"];
    [APIHELPER postWithURL:@"seat/select" param:param complete:complete];
}


/**
 剧场确认订单支付

 @param timeId <#timeId description#>
 @param payType <#payType description#>
 @param cardSn <#cardSn description#>
 @param couponSn <#couponSn description#>
 @param seats <#seats description#>
 @param complete <#complete description#>
 */
-(void)theaterCommitOrder:(NSInteger)timeId
                  payType:(NSInteger)payType
                   cardSn:(NSString *)cardSn
                 couponSn:(NSString *)couponSn
                    seats:(NSArray *)seats
                 complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(timeId) forKey:@"time_id"];
    [param safe_setValue:@(payType) forKey:@"pay_type"];
    [param safe_setValue:cardSn forKey:@"cardSn"];
    [param safe_setValue:couponSn forKey:@"couponSn"];
    [param safe_setValue:seats forKey:@"seats"];
    [APIHELPER postWithURL:@"theatre_order/order" param:param complete:complete];
}


/**
 剧场评价

 @param playId <#playId description#>
 @param orderId <#orderId description#>
 @param score <#score description#>
 @param content <#content description#>
 @param images <#images description#>
 @param complete <#complete description#>
 */
-(void)theaterComment:(NSInteger)playId
              orderId:(NSString *)orderId
                score:(NSInteger)score
              content:(NSString *)content
               images:(NSArray *)images
             complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(playId) forKey:@"play_id"];
    [param safe_setValue:orderId forKey:@"order_id"];
    [param safe_setValue:@(score) forKey:@"score"];
    [param safe_setValue:images forKey:@"show_img"];
    [APIHELPER postWithURL:@"theatre_comment/comment" param:param complete:complete];
}

@end
