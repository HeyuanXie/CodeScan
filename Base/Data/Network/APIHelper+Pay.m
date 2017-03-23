//
//  APIHelper+Pay.m
//  Base
//
//  Created by admin on 2017/3/22.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper+Pay.h"

@implementation APIHelper (Pay)

-(void)requestPayInfoWithParam:(NSDictionary *)param complete:(ApiRequestCompleteBlock)complete {
    
    [APIHELPER postWithURL:@"payApi" param:param complete:complete];
}

@end
