//
//  APIHelper+Admin.m
//  Base
//
//  Created by admin on 2017/5/8.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper+Admin.h"
#import "NSString+HYUtilities.h"

@implementation APIHelper (Admin)

- (void)login:(NSString *)account
     password:(NSString *)pw
     complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    NSString* salt = @"12345";
    NSString* sha1Str = [[[pw sha1String] lowercaseString] stringByAppendingString:salt];
    NSString* sha1PS = [[sha1Str sha1String] lowercaseString];
    [param safe_setValue:account forKey:@"account"];
    [param safe_setValue:sha1PS forKey:@"password"];
    [param safe_setValue:@"12345" forKey:@"salt"];
    [APIHELPER postWithURL:@"auth/adminLogin" param:param complete:complete];
}

- (void)codeScan:(NSString*)codeSn
            type:(NSInteger)type
        complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:codeSn forKey:@"code_sn"];
    [param safe_setValue:@(type) forKey:@"type"];
    [APIHELPER postWithURL:@"Order/scanOrder" param:param complete:complete];
}

- (void)printTicket:(NSInteger)orderId
            seatIds:(NSArray*)seats
           complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(orderId) forKey:@"order_id"];
    [param safe_setValue:seats forKey:@"seats"];
    [APIHELPER postWithURL:@"theatre_order/ticketCheck" param:param complete:complete];
}

- (void)deriveExchange:(NSInteger)orderId
              complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(orderId) forKey:@"order_id"];
    [APIHELPER postWithURL:@"goods_order/receive" param:param complete:complete];
}
@end
