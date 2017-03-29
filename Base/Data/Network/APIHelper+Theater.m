//
//  APIHelper+Theater.m
//  Base
//
//  Created by admin on 2017/3/29.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper+Theater.h"

@implementation APIHelper (Theater)

-(void)theaterHotCitysComplete:(ApiRequestCompleteBlock)complete {
    
    [APIHELPER getWithURL:@"movie/hotcity" param:nil complete:complete];
}

-(void)theaterListStart:(NSInteger)start
                  limit:(NSInteger)limit
                classId:(NSInteger)classId
              orderType:(NSString *)orderType
                   city:(NSString *)city
               complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(start) forKey:@"start"];
    [param safe_setValue:@(limit) forKey:@"limit"];
    [param safe_setValue:@(classId) forKey:@"class_id"];
    [param safe_setValue:orderType forKey:@"order_type"];
    [param safe_setValue:city forKey:@"city"];
    [APIHELPER getWithURL:@"" param:param complete:complete];
    
}

@end
