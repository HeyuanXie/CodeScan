//
//  APIHelper+Order.m
//  Base
//
//  Created by admin on 2017/4/1.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper+Order.h"

@implementation APIHelper (Order)

- (void)orderListTheater:(NSInteger)start limit:(NSInteger)limit complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [APIHELPER getWithURL:@"" param:param complete:complete];
}
- (void)orderDetailTheater:(NSString*)orderSn complete:(ApiRequestCompleteBlock)complete {
    
}

- (void)orderListLecture:(NSInteger)start limit:(NSInteger)limit complete:(ApiRequestCompleteBlock)complete {
    
}
- (void)orderDetailLecture:(NSString*)orderSn complete:(ApiRequestCompleteBlock)complete {
    
}

- (void)orderListDerive:(NSInteger)start limit:(NSInteger)limit statu:(NSInteger)statu complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(start) forKey:@"start"];
    [param safe_setValue:@(limit) forKey:@"limit"];
    [param safe_setValue:@(statu) forKey:@"status"];
    [APIHELPER getWithURL:@"goods_order/readlist" param:param complete:complete];
}
- (void)orderDetailDerive:(NSString*)orderSn complete:(ApiRequestCompleteBlock)complete {
    
    [APIHELPER getWithURL:@"goods_order/read" param:@{@"order_sn":orderSn} complete:complete];
}

- (void)orderListCard:(NSInteger)start limit:(NSInteger)limit statu:(NSInteger)statu complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(start) forKey:@"start"];
    [param safe_setValue:@(limit) forKey:@"limit"];
    [param safe_setValue:@(statu) forKey:@"status"];
    [APIHELPER getWithURL:@"card/orderList" param:param complete:complete];
}
- (void)orderDetailCard:(NSString*)orderSn complete:(ApiRequestCompleteBlock)complete {
    
}

@end
