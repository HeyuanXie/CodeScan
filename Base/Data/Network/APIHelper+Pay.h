//
//  APIHelper+Pay.h
//  Base
//
//  Created by admin on 2017/3/22.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper.h"

@interface APIHelper (Pay)

-(void)requestTheaterPayInfoWithParam:(NSDictionary*)param complete:(ApiRequestCompleteBlock)complete;
-(void)requestCardPayInfoWithParam:(NSDictionary*)param complete:(ApiRequestCompleteBlock)complete;

-(void)requestTheaterContinuePayInfoWithOrderId:(NSString*)orderId
                                       complete:(ApiRequestCompleteBlock)complete;
-(void)requestCardContinuePayInfoWithOrderId:(NSString*)orderId
                                       complete:(ApiRequestCompleteBlock)complete;

-(void)getPointWithPayId:(NSString*)payId payType:(NSInteger)payType complete:(ApiRequestCompleteBlock)complete;

@end
