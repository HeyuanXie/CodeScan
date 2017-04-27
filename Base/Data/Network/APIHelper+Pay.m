//
//  APIHelper+Pay.m
//  Base
//
//  Created by admin on 2017/3/22.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper+Pay.h"

@implementation APIHelper (Pay)

-(void)requestTheaterPayInfoWithParam:(NSDictionary *)param
                             complete:(ApiRequestCompleteBlock)complete {
    
    [APIHELPER postWithURL:@"theatre_order/order" param:param complete:complete];
}

-(void)requestCardPayInfoWithParam:(NSDictionary *)param
                          complete:(ApiRequestCompleteBlock)complete {
    
    [APIHELPER postWithURL:@"card/order" param:param complete:complete];
}



//继续支付
-(void)requestTheaterContinuePayInfoWithOrderId:(NSString*)orderId
                                       complete:(ApiRequestCompleteBlock)complete {
    
    [APIHELPER getWithURL:@"theatre_order/pay" param:@{@"order_id":orderId} complete:complete];
}

-(void)requestCardContinuePayInfoWithOrderId:(NSString *)orderId
                            complete:(ApiRequestCompleteBlock)complete {
    
    [APIHELPER getWithURL:@"card/pay" param:@{@"order_id":orderId} complete:complete];
}

-(void)getPointWithOutTradeNo:(NSString *)out_trade_no prepayId:(NSString *)prepayId complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:out_trade_no forKey:@"out_trade_no"];
    [param safe_setValue:prepayId forKey:@"prepayId"];
    [APIHELPER getWithURL:@"pay/detail" param:param complete:complete];
}

@end
