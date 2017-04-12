//
//  APIHelper+Home.m
//  Base
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper+Home.h"

@implementation APIHelper (Home)

-(void)fetchHomePageData:(NSString*)city complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:city forKey:@"city"];
    [APIHELPER getWithURL:@"index/index" param:param complete:complete];
}

-(void)homeSearch:(NSInteger)start
            limit:(NSInteger)limit
          keyword:(NSString*)keyword
             type:(NSString*)type
         complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(start) forKey:@"start"];
    [param safe_setValue:@(limit) forKey:@"limit"];
    [param safe_setValue:keyword forKey:@"key_word"];
    [param safe_setValue:type forKey:@"type"];
    [APIHELPER getWithURL:@"index/search" param:param complete:complete];
}

@end
