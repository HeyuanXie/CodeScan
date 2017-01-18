//
//  APIHelper+User.m
//  Base
//
//  Created by admin on 2017/1/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper+User.h"

@implementation APIHelper (User)

-(void)login:(NSString *)account password:(NSString *)pw complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* mDict = [NSMutableDictionary dictionary];
    [mDict safe_setValue:account forKey:@"account"];
    [mDict safe_setValue:pw forKey:@"password"];
    [APIHELPER postWithURL:@"/api/auth/login" param:mDict complete:complete];
}

@end
