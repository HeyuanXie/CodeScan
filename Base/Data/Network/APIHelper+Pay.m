//
//  APIHelper+Pay.m
//  Base
//
//  Created by admin on 2017/3/22.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper+Pay.h"

@implementation APIHelper (Pay)

-(void)requestTheaterPayInfoWithParam:(NSDictionary *)param complete:(ApiRequestCompleteBlock)complete {
    
    [APIHELPER postWithURL:@"theatre_order/order" param:param complete:complete];
}


-(void)requestCardPayInfoWithParam:(NSDictionary *)param complete:(ApiRequestCompleteBlock)complete {
    
    [APIHELPER postWithURL:@"card/order" param:param complete:complete];
}
@end
